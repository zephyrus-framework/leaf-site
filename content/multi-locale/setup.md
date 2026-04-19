---
title: Setup
order: 1
---

# Multi-Locale Setup

Leaf supports building your site in multiple languages. The default locale is served at the root URL; other locales get their own subdirectory (`dist/fr/`, `dist/ar/`, etc.).

**Scope:** Leaf's multi-locale is **string-level**, not content-level. Template strings (nav labels, buttons, hero copy) translate via JSON files. Markdown pages under `content/` are built once per locale using the same files; the translation happens through `localize()` calls inside your templates.

If you need per-language Markdown content, the common pattern is to gate sections in `config.yml` per locale and use branch logic in templates, or keep two separate Leaf sites under a shared domain. See the "Per-locale content" section below.

## Enable multi-locale

Edit `config.yml`:

```yaml
localization:
  locale: "en"                # Default locale (builds to dist/)
  supported_locales:
    - "en"
    - "fr"
    - "ar"
  locale_path: "locale"       # Directory containing translation files
  timezone: "America/Montreal"
```

When `supported_locales` has more than one entry, `leaf build` (or `composer build`) switches to multi-locale mode automatically.

## Translation files

`leaf init` scaffolds a `locale/` directory with an English starter:

```
locale/
  en/
    general.json
```

Add directories for every locale you declared:

```
locale/
  en/general.json
  fr/general.json
  ar/general.json
```

Example `locale/en/general.json`:

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

And `locale/fr/general.json`:

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

File names other than `general.json` work too — the loader merges every JSON file in a locale directory into one namespace.

## Using translations in templates

Drop `templates/` overrides that call `localize()`:

```latte
<h1>{localize('hero.title')}</h1>
<p>{localize('hero.subtitle')}</p>
```

The `i18n()` function is an alias.

Missing keys fall back to the key itself, so an untranslated page still renders without crashing.

## URL structure

With English as the default locale:

| Locale | URL | Directory |
|--------|-----|-----------|
| English (default) | `https://example.com/` | `dist/` |
| French | `https://example.com/fr/` | `dist/fr/` |
| Arabic | `https://example.com/ar/` | `dist/ar/` |

The default locale has no URL prefix. This gives cleaner URLs for your primary language and better SEO.

## Template variables

The `TranslationLatteExtension` injects these variables into every template:

| Variable | Type | Description |
|----------|------|-------------|
| `$currentLocale` | string | Active locale code (`en`, `fr`, etc.) |
| `$defaultLocale` | string | Default locale from config |
| `$supportedLocales` | array | All supported locale codes |

Use them to render language switchers:

```latte
<select onchange="location = this.value">
  {foreach $supportedLocales as $code}
    <option value="{$code === $defaultLocale ? '/' : '/' . $code . '/'}"
            {if $code === $currentLocale}selected{/if}>{$code}</option>
  {/foreach}
</select>
```

## Binary CLI vs Composer

Both paths build multi-locale identically. `leaf build` reads `config.yml` and your `locale/` directory, then produces the per-locale subdirectories under `dist/`. Same for `composer build`.

If you started from `leaf init` and removed the scaffolded `locale/` dir, recreate it:

```bash
mkdir -p locale/en
echo '{}' > locale/en/general.json
```

## Per-locale content (advanced)

If you need translated Markdown pages (not just template strings), Leaf doesn't offer a built-in mechanism today. Two workable patterns:

1. **Branch on locale in the template.** Keep one Markdown file; gate sections with `{if $currentLocale === 'fr'}...{/if}`. Fine for small amounts of translated prose.
2. **Sibling project per locale.** Run two Leaf sites (one per language) and front them with a shared domain + path rewrite at the CDN layer. Each site is monolingual under the hood.

Native per-locale content is on the roadmap. Open an issue if you need it.
