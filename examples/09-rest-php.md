# Пример 9 — REST на PHP / Laravel

## Чистый PHP (без зависимостей)

`createya.php`:

```php
<?php
declare(strict_types=1);

class CreateyaClient
{
    private const API = 'https://api.createya.ai/v1';
    private string $apiKey;

    public function __construct(?string $apiKey = null)
    {
        $this->apiKey = $apiKey ?? getenv('CREATEYA_API_KEY') ?: '';
        if ($this->apiKey === '') {
            throw new \RuntimeException('CREATEYA_API_KEY env var is not set');
        }
    }

    /** @param array<string, mixed> $input */
    public function run(string $model, array $input, ?string $webhookUrl = null): array
    {
        $body = ['model' => $model, 'input' => $input];
        if ($webhookUrl) $body['webhook_url'] = $webhookUrl;

        return $this->request('POST', '/run', $body);
    }

    public function getRun(string $runId): array
    {
        return $this->request('GET', "/runs/{$runId}");
    }

    public function poll(string $runId, int $maxWaitSec = 600): array
    {
        $deadline = time() + $maxWaitSec;
        $delay = 5;
        while (time() < $deadline) {
            $r = $this->getRun($runId);
            if ($r['status'] === 'completed') return $r;
            if ($r['status'] === 'failed') {
                throw new \RuntimeException(
                    'Run failed: ' . ($r['error']['message'] ?? 'unknown')
                );
            }
            sleep($delay);
            $delay = min($delay * 2, 30);
        }
        throw new \RuntimeException("Poll timeout for {$runId}");
    }

    public function balance(): array
    {
        return $this->request('GET', '/balance');
    }

    private function request(string $method, string $path, ?array $body = null): array
    {
        $ch = curl_init(self::API . $path);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CUSTOMREQUEST => $method,
            CURLOPT_HTTPHEADER => [
                'Authorization: Bearer ' . $this->apiKey,
                'Content-Type: application/json',
            ],
            CURLOPT_TIMEOUT => 60,
        ]);
        if ($body !== null) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($body, JSON_UNESCAPED_UNICODE));
        }

        $resp = curl_exec($ch);
        $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($code >= 400) {
            throw new \RuntimeException("Createya HTTP {$code}: {$resp}");
        }

        return json_decode($resp, true, flags: JSON_THROW_ON_ERROR);
    }
}
```

Использование:

```php
$createya = new CreateyaClient();

// Sync
$img = $createya->run('nano-banana-2', [
    'prompt' => 'кот на луне в стиле Studio Ghibli',
    'aspect_ratio' => '16:9',
]);
echo $img['output']['urls'][0] . PHP_EOL;

// Async (video)
$queued = $createya->run('kling-video-o3', [
    'image_url' => $img['output']['urls'][0],
    'duration' => 5,
]);
$video = $createya->poll($queued['run_id'], 600);
echo $video['output']['url'] . PHP_EOL;

// Balance
echo $createya->balance()['credits'] . PHP_EOL;
```

## Laravel — service + controller

### Service: `app/Services/Createya.php`

```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class Createya
{
    private const API = 'https://api.createya.ai/v1';

    private function client()
    {
        return Http::withToken(config('services.createya.key'))
            ->acceptJson()
            ->timeout(60);
    }

    public function run(string $model, array $input): array
    {
        $r = $this->client()->post(self::API . '/run', [
            'model' => $model,
            'input' => $input,
        ]);
        $r->throw();
        return $r->json();
    }

    public function getRun(string $runId): array
    {
        $r = $this->client()->get(self::API . "/runs/{$runId}");
        $r->throw();
        return $r->json();
    }

    /**
     * Запустить async run и сразу вернуть run_id.
     * Polling делается через job (см. ProcessCreateyaRun).
     */
    public function runAsync(string $model, array $input, string $webhookUrl): string
    {
        $r = $this->run($model, $input + ['webhook_url' => $webhookUrl]);
        return $r['run_id'];
    }
}
```

### Конфиг: `config/services.php`

```php
'createya' => [
    'key' => env('CREATEYA_API_KEY'),
],
```

### Controller: `app/Http/Controllers/GenerateController.php`

```php
<?php

namespace App\Http\Controllers;

use App\Services\Createya;
use Illuminate\Http\Request;

class GenerateController extends Controller
{
    public function __construct(private Createya $createya) {}

    public function image(Request $request)
    {
        $request->validate([
            'prompt' => 'required|string|max:2000',
            'aspect_ratio' => 'nullable|string',
        ]);

        $result = $this->createya->run('nano-banana-2', [
            'prompt' => $request->input('prompt'),
            'aspect_ratio' => $request->input('aspect_ratio', '1:1'),
        ]);

        return response()->json([
            'image_url' => $result['output']['urls'][0],
            'credits_used' => $result['credits_used'] ?? null,
        ]);
    }
}
```

### Webhook receiver: `routes/api.php`

```php
Route::post('/webhooks/createya', function (\Illuminate\Http\Request $request) {
    // Опционально: верифицировать source через подпись (если включишь)
    $payload = $request->all();

    // payload: {id, object: "run.completed"|"run.failed", status, model, output, credits_used}
    \Log::info('Createya webhook', $payload);

    if ($payload['status'] === 'completed') {
        // Сохранить URL в БД, нотифицировать пользователя, etc.
        \App\Models\Generation::where('run_id', $payload['id'])
            ->update([
                'status' => 'completed',
                'output_url' => $payload['output']['urls'][0] ?? null,
            ]);
    }

    return response()->json(['ok' => true]);
});
```

## Symfony — `HttpClientInterface`

```php
<?php

namespace App\Createya;

use Symfony\Contracts\HttpClient\HttpClientInterface;

class CreateyaClient
{
    public function __construct(
        private HttpClientInterface $http,
        private string $apiKey,
    ) {}

    public function run(string $model, array $input): array
    {
        $r = $this->http->request('POST', 'https://api.createya.ai/v1/run', [
            'auth_bearer' => $this->apiKey,
            'json' => ['model' => $model, 'input' => $input],
            'timeout' => 60,
        ]);
        return $r->toArray();
    }
}
```

`config/services.yaml`:

```yaml
services:
    App\Createya\CreateyaClient:
        arguments:
            $apiKey: '%env(CREATEYA_API_KEY)%'
```

## Связанные примеры

- [`03-async-polling.md`](03-async-polling.md) — async pattern
- [`04-upload-image.md`](04-upload-image.md) — uploads
- [`10-error-handling.md`](10-error-handling.md) — обработка ошибок
