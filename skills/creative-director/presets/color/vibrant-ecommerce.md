---
name: vibrant-ecommerce
type: color
display_name: Vibrant ecommerce (маркетплейс)
tags: [saturated, clean, ecommerce, bright, accurate-color]
fits_categories: [ecommerce]
not_for: [fashion, portfolio, ugc, product_artistic]
inject_text: |
  Vibrant ecommerce color grade: accurate white balance neutral (daylight 5500K, zero tint shift), global saturation +20%, contrast +10 (moderate S-curve, blacks to true 0, highlights at 245-250 max), no shadow lift — pure white and pure black available. True-to-product color accuracy — no creative shifts in any HSL channel. Slight clarity +10 for product texture detail. No film grain, no vignette. Clean, bright, commercial catalog appearance — colors exactly as they appear in real life under neutral daylight.
---

# Vibrant ecommerce

## Кратко
Нейтральный WB, +20% saturation, умеренный контраст. Цвета точные и насыщенные — как в жизни при дневном свете. Стандарт Wildberries, Ozon, Amazon, любых маркетплейсов.

## Технические параметры
- **White Balance**: строго нейтральный, 5500K, tint = 0 (никаких творческих сдвигов)
- **Global saturation**: +20% (Lightroom Vibrance +15, Saturation +5)
- **Contrast**: +10 moderate (S-curve: shadows к RGB 5-8, highlights к 245-250 max)
- **Blacks**: pure (RGB 5-8) — нет shadow lift
- **Highlights**: чистые (RGB 245-250) — без blown-out clip
- **HSL**: никаких корректировок по каналам — максимальная color accuracy
- **Clarity**: +10 (микроконтраст для texture продукта)
- **Grain / vignette**: ноль
- **Skin tones**: нейтральные и accurate (не warmed, не cooled)

## Когда подходит
- Маркетплейс листинг (Wildberries, Ozon, Amazon, AliExpress)
- Каталогная фотография — тысячи SKU, воспроизводимость критична
- Ecommerce где покупатель принимает решение по цвету товара
- Обувь, одежда, текстиль — точная цветопередача = меньше возвратов
- Бытовая техника, электроника — product color match to box

## Когда НЕ подходит
- Fashion editorial и creative portfolio — нет художественного характера
- Product artistic luxury — нужна атмосфера, а не accuracy → `luxury-muted` или `editorial-deep-blacks`
- UGC — слишком commercial для authentic feel
- Beauty creative — нет warmth и mood → `filmic-warm`

## Как читается на финальном фото
Продукт выглядит ярко и точно — "как в жизни, только чуть лучше". Белые фон чистый, чёрные не размытые. Красный — красный, синий — синий, без creative drift. Покупатель знает что получит. Профессионально и коммерчески безупречно — но без soul.
