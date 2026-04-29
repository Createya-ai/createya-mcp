# Пример 8 — REST на Go

Минималистичная реализация без сторонних зависимостей (`net/http` + `encoding/json`).

## Установка

```bash
mkdir createya-go && cd createya-go
go mod init example.com/createya
```

`go.mod` останется пустым — мы используем только stdlib.

## Основной клиент (`createya.go`)

```go
package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"
)

const apiBase = "https://api.createya.ai/v1"

type RunRequest struct {
	Model      string                 `json:"model"`
	Input      map[string]interface{} `json:"input"`
	WebhookURL string                 `json:"webhook_url,omitempty"`
}

type RunResponse struct {
	RunID   string `json:"run_id"`
	Status  string `json:"status"` // queued | in_progress | completed | failed
	Output  struct {
		URLs []string `json:"urls,omitempty"`
		URL  string   `json:"url,omitempty"`
	} `json:"output,omitempty"`
	Error *struct {
		Code    string `json:"code"`
		Message string `json:"message"`
	} `json:"error,omitempty"`
	CreditsUsed int `json:"credits_used,omitempty"`
}

type Client struct {
	APIKey string
	HTTP   *http.Client
}

func NewClient() *Client {
	return &Client{
		APIKey: os.Getenv("CREATEYA_API_KEY"),
		HTTP:   &http.Client{Timeout: 60 * time.Second},
	}
}

func (c *Client) Run(model string, input map[string]interface{}) (*RunResponse, error) {
	body, err := json.Marshal(RunRequest{Model: model, Input: input})
	if err != nil {
		return nil, err
	}
	req, _ := http.NewRequest("POST", apiBase+"/run", bytes.NewReader(body))
	req.Header.Set("Authorization", "Bearer "+c.APIKey)
	req.Header.Set("Content-Type", "application/json")

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode >= 400 {
		raw, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("createya: HTTP %d: %s", resp.StatusCode, string(raw))
	}

	var out RunResponse
	if err := json.NewDecoder(resp.Body).Decode(&out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (c *Client) GetRun(runID string) (*RunResponse, error) {
	req, _ := http.NewRequest("GET", apiBase+"/runs/"+runID, nil)
	req.Header.Set("Authorization", "Bearer "+c.APIKey)

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode >= 400 {
		raw, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("createya: HTTP %d: %s", resp.StatusCode, string(raw))
	}

	var out RunResponse
	if err := json.NewDecoder(resp.Body).Decode(&out); err != nil {
		return nil, err
	}
	return &out, nil
}

// Poll опрашивает run до завершения. delay растёт по 5,10,20,30,30...
func (c *Client) Poll(runID string, maxWait time.Duration) (*RunResponse, error) {
	deadline := time.Now().Add(maxWait)
	delay := 5 * time.Second

	for time.Now().Before(deadline) {
		r, err := c.GetRun(runID)
		if err != nil {
			return nil, err
		}
		switch r.Status {
		case "completed":
			return r, nil
		case "failed":
			if r.Error != nil {
				return nil, fmt.Errorf("run failed: %s — %s", r.Error.Code, r.Error.Message)
			}
			return nil, errors.New("run failed")
		}
		time.Sleep(delay)
		if delay < 30*time.Second {
			delay *= 2
		}
	}
	return nil, errors.New("poll timeout")
}
```

## Использование (`main.go`)

```go
package main

import (
	"fmt"
	"log"
	"time"
)

func main() {
	c := NewClient()
	if c.APIKey == "" {
		log.Fatal("set CREATEYA_API_KEY env var")
	}

	// Sync: image
	img, err := c.Run("nano-banana-2", map[string]interface{}{
		"prompt":       "кот на луне в стиле Studio Ghibli",
		"aspect_ratio": "16:9",
	})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Image URL:", img.Output.URLs[0])

	// Async: video
	queued, err := c.Run("kling-video-o3", map[string]interface{}{
		"image_url": img.Output.URLs[0],
		"duration":  5,
	})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Queued:", queued.RunID)

	video, err := c.Poll(queued.RunID, 5*time.Minute)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Video URL:", video.Output.URL)
}
```

## Запуск

```bash
export CREATEYA_API_KEY=crya_sk_live_...
go run .
```

## Загрузка локального файла (для image-to-image)

```go
import (
	"bytes"
	"mime/multipart"
	"os"
)

func (c *Client) Upload(filepath string) (string, error) {
	file, err := os.Open(filepath)
	if err != nil {
		return "", err
	}
	defer file.Close()

	var body bytes.Buffer
	w := multipart.NewWriter(&body)
	part, _ := w.CreateFormFile("file", filepath)
	if _, err := io.Copy(part, file); err != nil {
		return "", err
	}
	w.Close()

	req, _ := http.NewRequest("POST", apiBase+"/uploads", &body)
	req.Header.Set("Authorization", "Bearer "+c.APIKey)
	req.Header.Set("Content-Type", w.FormDataContentType())

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	var out struct {
		URL string `json:"url"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&out); err != nil {
		return "", err
	}
	return out.URL, nil
}
```

## Связанные примеры

- [`03-async-polling.md`](03-async-polling.md) — детали polling и retry
- [`04-upload-image.md`](04-upload-image.md) — uploads
- [`10-error-handling.md`](10-error-handling.md) — обработка ошибок
