---
title: Setup
order: 1
---

# Multi-Locale Setup

Leaf builds your site in multiple languages. The default locale goes to the root URL; other locales get their own subdirectory (`dist/fr/`, `dist/ar/`, etc.).

Two layers of translation work together:

1. **String-level** — UI chrome (nav labels, button text, search placeholder) translated via JSON files and `{localize('key')}` in templates.
2. **Content-level** — Markdown pages under `content/<locale>/...` that override the default-locale pages with translations. Untranslated pages fall back to the default.

Both are enabled by the same config and work in both tiers (Binary CLI, Composer).

## Enable multi-locale

Edit `config.yml`:

```yaml
localization:
  locale: "en"                # Default locale (builds to dist/)
  supported_locales:
    - "en"
    - "fr"
    - "ar"
  locale_path: "locale"       # Directory containing translation JSON files
  timezone: "America/Montreal"
```

With more than one entry in `supported_locales`, `leaf build` switches to multi-locale mode automatically: it iterates every locale, invoking the full pipeline once per locale, writing each into its own output subdirectory. A language switcher also appears in the nav automatically (no markup needed from you).

## String-level translations

`leaf init` scaffolds a `locale/` directory with an English starter:

```
locale/
  en/general.json
```

Add a directory per locale:

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
  }
}
```

And `locale/fr/general.json`:

```json
{
  "nav": {
    "home": "Accueil",
    "docs": "Documentation"
  }
}
```

Any file under a locale directory is merged into one namespace, so you can split long translation files however you like (`general.json`, `legal.json`, `marketing.json`).

Use them in templates:

```latte
<a href="/">{localize('nav.home')}</a>
<a href="/docs">{localize('nav.docs')}</a>
```

`i18n()` is an alias for `localize()`. Missing keys fall back to the key itself, so the page still renders.

## Content-level translations

Markdown pages live under `content/`. To translate them, drop a locale-scoped folder inside:

```
content/
  getting-started/
    intro.md              # default (English)
    installation.md       # default only, not translated yet
  fr/
    getting-started/
      intro.md            # French override
  ar/
    getting-started/
      intro.md            # Arabic override
    concepts/
      overview.md         # Arabic-only section
```

Resolution rules per build:

| URL | Source file |
|-----|-------------|
| `/getting-started/intro/` (en) | `content/getting-started/intro.md` |
| `/fr/getting-started/intro/` | `content/fr/getting-started/intro.md` |
| `/fr/getting-started/installation/` | falls back to `content/getting-started/installation.md` (not translated) |
| `/ar/concepts/overview/` | `content/ar/concepts/overview.md` (Arabic-only section) |

The default locale only sees files at the root of `content/` — it will not render locale-only pages (so `/concepts/overview/` is a 404 in English). Non-default locales see the union.

The **search index** is generated per locale. `/search.json` only returns English/fallback entries; `/fr/search.json` returns the translated pages plus English fallbacks. Fuzzy search stays fast and locale-relevant.

## URL structure

With English as the default locale:

| Locale | URL | Directory |
|--------|-----|-----------|
| English (default) | `https://example.com/` | `dist/` |
| French | `https://example.com/fr/` | `dist/fr/` |
| Arabic | `https://example.com/ar/` | `dist/ar/` |

The default locale has no URL prefix. Cleaner URLs for the primary language, better SEO, zero-click landing for most visitors.

## Template variables

Every template receives:

| Variable | Type | Description |
|----------|------|-------------|
| `$currentLocale` | string | Active locale code (`en`, `fr`, etc.) |
| `$defaultLocale` | string | Default locale from config |
| `$supportedLocales` | array | All supported locale codes |

Use them for language switchers, hreflang tags, and locale-prefixed links.

## Language switcher

The bundled nav automatically renders a language switcher when `supported_locales` has more than one entry. It sits next to the theme toggle, shows the current locale code, and its dropdown links preserve the current path when switching (so clicking `FR` from `/guides/auth/` takes you to `/fr/guides/auth/`, not the French landing).

If you customise the nav via `templates/partials/nav.latte`, copy the switcher block from the bundled template or render your own. The JavaScript helper is loaded automatically from `/assets/js/lang-switcher.js`.

## Hreflang and canonical

When `production_url` is set, the build generates `sitemap.xml` with `xhtml:link` hreflang alternates for every page. For canonical and `<link rel="alternate" hreflang=...>` tags inside page templates, thread `$requestPath` through from controllers (Composer tier) or rely on the bundled head partial (both tiers).

## SEO and fallback marking

A page that falls back to the default locale gets the same markup as a translated page. If you want to mark partially-translated pages visually (a small "English" badge, say), check `$currentLocale` in the template and add a conditional banner — the loader doesn't attach metadata to fallback pages.

## Sidebar differences across locales

Because content-level translations can add locale-only sections, the sidebar can legitimately differ between locales. That's the point. The bundled sidebar renders what's available for the current locale (union of default + locale-scoped files). Configured section order from `config.yml` is respected; locale-only sections slot in at their configured position or alphabetically after configured sections.

## Single-locale sites

If you want one language, leave `supported_locales` at a single entry (or omit the section entirely). `leaf build` stays in single-locale mode: no subdirectories, no language switcher, no per-locale search index. Everything works as the lean static pipeline you'd expect.
