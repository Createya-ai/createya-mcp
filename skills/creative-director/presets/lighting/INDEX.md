# Lighting presets

Профессиональные схемы света. Группировка по типу источника.

## Studio (контролируемый свет)

| Slug | Название | Tags | Подходит для |
|---|---|---|---|
| `soft-three-point` | Мягкий three-point | studio, classic, balanced, beauty | fashion, personal_brand, portfolio, ecommerce |
| `rembrandt` | Свет Рембрандта (45/45) | studio, classic, dramatic, painterly | personal_brand, portfolio, fashion editorial |
| `loop` | Loop lighting (петля) | studio, classic, flattering, beauty | personal_brand, portfolio, fashion |
| `butterfly` | Butterfly / Paramount | studio, glamour, beauty, fashion | beauty, fashion, personal_brand |
| `split` | Split lighting (90°) | studio, dramatic, editorial, contrast | fashion editorial, personal_brand creative |
| `broad` | Broad lighting | studio, flattering, full-face | personal_brand, portfolio (округлый тип лица) |
| `short` | Short lighting | studio, slimming, sculpting | personal_brand, portfolio (full-face / chubby) |
| `beauty-clamshell` | Beauty clamshell | studio, beauty, flat, glow | beauty, ecommerce cosmetics, fashion close-up |
| `hard-light-single` | Hard single source | studio, contrasty, editorial, Newton | fashion editorial, product_artistic moody |
| `ring-light` | Ring light | studio, beauty, influencer, flat | personal_brand, beauty UGC, ugc polished |
| `strip-side` | Strip light side | studio, sculpting, body | fashion full-body, fitness portfolio |
| `beauty-dish` | Beauty dish | studio, fashion, sharper-than-softbox | fashion, beauty, personal_brand pro |
| `tabletop-tent` | Tabletop softbox tent | studio, ecommerce, even, white-background | ecommerce товары, флэт-лей |
| `edge-light-product` | Edge light на чёрном | studio, dramatic, product, outline | product_artistic, premium ecommerce |
| `macro-ring-flash` | Macro ring flash | studio, macro, jewelry, even | ecommerce ювелирка/мелкая электроника |

## Natural (естественный свет)

| Slug | Название | Tags | Подходит для |
|---|---|---|---|
| `natural-window` | Естественный из окна | natural, soft, daylight, indoor | personal_brand, fashion lifestyle, ugc |
| `golden-hour` | Магический час | natural, warm, outdoor, cinematic | fashion, personal_brand creative, lifestyle |
| `blue-hour` | Синий час | natural, ambient, moody, cinematic | fashion editorial, personal_brand creative |
| `overcast-diffused` | Пасмурный диффузный | natural, even, no-shadow, fashion | fashion, portfolio outdoor, ecommerce outdoor |
| `backlight-silhouette` | Контровой / силуэт | natural, dramatic, silhouette | fashion editorial, creative portfolio |
| `mixed-practical` | Микс окно + practicals | natural+ambient, lifestyle, cinematic | personal_brand interior, ugc, lifestyle |

## Creative / atypical

| Slug | Название | Tags | Подходит для |
|---|---|---|---|
| `high-key` | High-key (почти без теней) | bright, airy, beauty, optimistic | beauty, ecommerce, personal_brand light |
| `low-key-chiaroscuro` | Low-key chiaroscuro | dark, dramatic, painterly, moody | product_artistic, fashion editorial dark |
| `colored-gels-split` | Colored gels (двухцветный) | creative, neon, editorial, vibrant | fashion editorial, music/beauty editorial |
| `practical-only` | Только practicals в кадре | cinematic, narrative, mood, indoor | personal_brand creative, lifestyle cinematic |

## Как комбинировать с color/

| Lighting | Хорошо с color preset |
|---|---|
| `soft-three-point` + `beauty-dish` | `luxury-muted`, `hi-key-clean`, `editorial-deep-blacks` |
| `golden-hour` | `filmic-warm`, `sunset-golden-warm`, `cinematic-teal-orange` |
| `low-key-chiaroscuro` | `editorial-deep-blacks`, `bleach-bypass`, `bw-high-contrast` |
| `natural-window` | `filmic-warm`, `lifestyle-natural` |
| `tabletop-tent` | `vibrant-ecommerce`, `hi-key-clean` |
| `colored-gels-split` | `cinematic-teal-orange`, `vibrant-ecommerce` |

## Дефолты по категориям (если юзер не указал свет)

| Категория | Default lighting |
|---|---|
| `ecommerce` | `tabletop-tent` (товары) или `soft-three-point` (одежда на манекене) |
| `fashion` | `soft-three-point` (studio) или `golden-hour` (outdoor editorial) |
| `personal_brand` | `natural-window` или `soft-three-point` |
| `portfolio` | `soft-three-point` |
| `product_artistic` | `low-key-chiaroscuro` или `edge-light-product` или `golden-hour` |
| `ugc` | `natural-window` или `ring-light` (если selfie-стиль) |
