---
title: Setup
order: 1
---

# Multi-Locale Setup

Leaf supports building your site in multiple languages. The default locale is served at the root URL, and other locales get their own subdirectory.

## Configuration

Enable multi-locale in `config.yml`:

```yaml
localization:
  locale: "en"                # Default locale (builds to root)
  supported_locales:
    - "en"
    - "fr"
    - "ar"
  locale_path: "locale"       # Directory containing translation files
  timezone: "America/Montreal"
```

## Translation files

Create JSON files for each locale:

```
locale/
  en/
    strings.json
  fr/
    strings.json
  ar/
    strings.json
```

Example `locale/en/strings.json`:

```json
{
  "nav": {
    "home": "Home",
    "docs": "Documentation"
  },
  "hero": {
    "title": "Build beautiful static sites",
    "subtitle": "One command. Any language."
  }
}
```

And `locale/fr/strings.json`:

```json
{
  "nav": {
    "home": "Accueil",
    "docs": "Documentation"
  },
  "hero": {
    "title": "Construisez de beaux sites statiques",
    "subtitle": "Une commande. N'importe quelle langue."
  }
}
```

## Using translations in templates

In Latte templates, use the `localize()` function:

```latte
<h1>{localize('hero.title')}</h1>
<p>{localize('hero.subtitle')}</p>
```

The `i18n()` function is an alias for `localize()`.

## URL structure

With English as the default locale:

| Locale | URL | Directory |
|--------|-----|-----------|
| English (default) | `https://example.com/` | `dist/` |
| French | `https://example.com/fr/` | `dist/fr/` |
| Arabic | `https://example.com/ar/` | `dist/ar/` |

The default locale has **no URL prefix**. This gives cleaner URLs for your primary language and better SEO.

## Template variables

The `TranslationLatteExtension` injects these variables into every template:

| Variable | Type | Description |
|----------|------|-------------|
| `$currentLocale` | string | Active locale code ("en", "fr", etc.) |
| `$defaultLocale` | string | Default locale from config |
| `$supportedLocales` | array | All supported locale codes |
