---
title: Setup
order: 1
description: Set up a multilingual Leaf site, with i18n strings, translated pages in French or any other locale under their own URL prefix, and fallback to the default locale.
---

# Multi-Locale Setup

Leaf builds multilingual sites (i18n): the default locale, English for example, goes to the root URL, and every other locale, such as French or Arabic, gets its own subdirectory (`dist/fr/`, `dist/ar/`, etc.).

Two layers of translation work together:

1. **String-level**: UI chrome (nav labels, button text, search placeholder) translated via JSON files and `{localize('key')}` in templates.
2. **Content-level**: Markdown pages under `content/<locale>/...` that override the default-locale pages with translations. Untranslated pages fall back to the default.

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

### Locale codes

Each locale becomes a directory and a URL segment, so Leaf checks every code before it builds anything. A code is a language of 2 or 3 letters, optionally followed by hyphenated subtags of 2 to 8 letters or digits: `fr`, `fr-ca`, `pt-br`. Values are lowercased first, so `fr-CA` is accepted and builds to `dist/fr-ca/`, served at `/fr-ca/`.

Any other value stops the build before it writes anything, with an uncaught `ConfigurationException` whose message names the value. `fr_CA` comes with a hint:

> Configuration section 'localization' field 'supported_locales' has invalid value "fr_ca": a lowercase language code of 2 or 3 letters, optionally followed by hyphenated subtags of 2 to 8 letters or digits (such as "fr" or "fr-ca"); use a hyphen, such as "fr-ca".

Values such as `../x` or `/x.example` are refused the same way. The default `locale` follows the same rule and must be one of `supported_locales`, since it is the locale built at the site root:

> Configuration section 'localization' field 'locale' has invalid value "de": one of the supported_locales (en, fr), since the default locale is built at the site root; set locale to one of them, or add "de" to supported_locales.

## String-level translations

`leaf init` scaffolds a `locale/` directory with the theme's English and French strings:

```
locale/
  en/general.json
  fr/general.json
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

On the Binary CLI, your files are merged key by key over the bundled theme's own `locale/<locale>/general.json`, and your keys win. A `locale/en/general.json` that sets only `search.empty` changes that one string; every other theme string keeps its bundled text. The theme ships English and French strings; for another locale, translate its keys in `locale/<locale>/general.json` (copy them from the English file).

On the Composer tier nothing is merged: your `locale/` is the complete catalog, the theme's strings included, so edit those files and add your keys to them rather than replacing them with only yours (a key found in no catalog renders as the key itself).

Without `locale_path`, Leaf reads `locale/` at the project root when that directory exists.

Use them in templates:

```latte
<a href="{$leafBaseUrl}{$localePrefix}/">{localize('nav.home')}</a>
<a href="{$leafBaseUrl}{$localePrefix}/docs">{localize('nav.docs')}</a>
```

`i18n()` is an alias for `localize()`. A key missing in a locale falls back to the default locale's value, then to the key itself, so the page still renders.

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

The default locale only sees files at the root of `content/`: it will not render locale-only pages (so `/concepts/overview/` is a 404 in English). Non-default locales see the union.

The **search index** is generated per locale. `/search.json` lists the English pages; `/fr/search.json` lists the translated pages plus the English fallbacks, with their `/fr/` URLs. Each page searches the index of its own locale, so results stay on the reader's version of the site.

## URL structure

With English as the default locale:

| Locale | URL | Directory |
|--------|-----|-----------|
| English (default) | `https://example.com/` | `dist/` |
| French | `https://example.com/fr/` | `dist/fr/` |
| Arabic | `https://example.com/ar/` | `dist/ar/` |

The default locale has no URL prefix. Cleaner URLs for the primary language, better SEO, zero-click landing for most visitors.

## 404 pages

Each locale gets its own 404 page: the default locale's at `dist/404.html`, every other one at `dist/<locale>/404.html` (`/fr/404.html`). A host that serves the nearest `404.html` shows the right language directly. A host that serves only the root one, such as GitHub Pages, answers a missing `/fr/...` URL with the default locale's page, whose script then sends the visitor to `/fr/404.html`; without JavaScript, that page links to the home page of every other locale. A site that overrides `404.latte` must copy that script from the theme's file.

## Dev servers

`leaf dev` builds every locale and serves `dist/`, so `/fr/...` behaves as in production, 404 included.

`composer dev` (Composer tier) renders each request live. It serves `/<locale>/...` from `content/<locale>/` for every non-default locale in `supported_locales`, subtags included (`/fr-ca/...`). Any other first segment stays in the path: `/en/...` for a default locale `en` is a 404, as in `dist/`.

## Template variables

Every template receives:

| Variable | Type | Description |
|----------|------|-------------|
| `$currentLocale` | string | Active locale code (`en`, `fr`, etc.) |
| `$defaultLocale` | string | Default locale from config |
| `$supportedLocales` | array | All supported locale codes (`[]` when the config declares none) |
| `$localePrefix` | string | `''` for the default locale, `'/fr'` for French. Always defined, on a single-locale site too |

Use them for language switchers, hreflang tags, and locale-prefixed links. A variable your controller passes, or one your template sets with `{var}`, wins over these.

## Language switcher

The bundled nav renders a language switcher when `supported_locales` has more than one entry. It sits next to the theme toggle: a globe button with the current locale code opens a menu of locale codes. Each link keeps the current page and the base URL, so `FR` on `/docs/guides/auth/` leads to `/docs/fr/guides/auth/`, not to the French landing. On the 404 page, the links lead to each locale's home page instead. The switcher does not check that the page exists in the other locale: from a page that exists only under `content/fr/`, `EN` leads to a 404.

The menu works from the keyboard: Tab reaches the button, Enter opens the menu, Escape closes it and returns focus to the button.

If you customise the nav via `templates/partials/nav.latte`, copy the switcher block from [Templates & Links](/multi-locale/templates/#language-switcher). The bundled layouts load its script, `/assets/js/lang-switcher.js`.

## Hreflang and canonical

When `production_url` is set, the build generates `sitemap.xml` with `xhtml:link` hreflang alternates for every page. The bundled head writes no canonical or hreflang tag: add them in an overridden `templates/partials/head.latte`, as shown in [Templates & Links](/multi-locale/templates/#canonical-and-hreflang-tags).

## SEO and fallback marking

A page that falls back to the default locale gets the same markup as a translated page. If you want to mark partially-translated pages visually (a small "English" badge, say), check `$currentLocale` in the template and add a conditional banner. The loader doesn't attach metadata to fallback pages.

## Sidebar differences across locales

Because content-level translations can add locale-only sections, the sidebar can legitimately differ between locales. That's the point. The bundled sidebar renders what's available for the current locale (union of default + locale-scoped files). Configured section order from `config.yml` is respected; locale-only sections slot in at their configured position or alphabetically after configured sections.

## Single-locale sites

If you want one language, leave `supported_locales` at a single entry (or omit the section entirely). `leaf build` stays in single-locale mode: no subdirectories, no language switcher, no per-locale search index. Everything works as the lean static pipeline you'd expect.
