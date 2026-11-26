# leaf.ophelios.com

The landing and documentation site for [Zephyrus Leaf](https://github.com/zephyrus-framework/leaf-cli), published at [leaf.ophelios.com](https://leaf.ophelios.com).

This repo also serves the install script at [leaf.ophelios.com/install.sh](https://leaf.ophelios.com/install.sh), which is how users install the `leaf` CLI.

## Dogfooding

This site is itself a Binary CLI tier Leaf project. It has no `app/`, `bin/`, `vendor/`, or `composer.json`. Everything user-authored lives in `content/`, `templates/`, `public/`, and `config.yml`. The site rebuilds with the same `leaf` CLI it teaches people to install.

## Requirements

- The `leaf` CLI. Install with:
  ```sh
  curl -fsSL https://leaf.ophelios.com/install.sh | sh
  ```
- System PHP 8.4+ with `intl`, `mbstring`, `sodium`, `pdo` extensions (the `leaf` binary shells out to it until FrankenPHP static link lands).
- Google Chrome (only for regenerating the OG social card via `scripts/generate-og-image.sh`).

## Layout

```
.
├── content/                         # Markdown docs, organized by section
├── templates/                       # Overrides for the bundled theme
│   ├── landing.latte                # Home page with binary/composer tabs, on layouts/home.latte
│   ├── layouts/home.latte           # Home wrapper: landing.css + landing.js, no theme nav or footer
│   ├── layouts/docs.latte           # Theme docs layout minus its <title>
│   ├── layouts/landing.latte        # Theme landing layout (used by the 404) minus its <title>
│   ├── partials/head.latte          # The <title>, SEO meta, canonical, OG tags, favicons
│   └── partials/nav.latte           # Theme nav with the Leaf logo image
├── public/
│   ├── assets/css/                  # landing.css (app.css comes from the theme)
│   ├── assets/js/                   # landing.js (the docs scripts come from the theme)
│   ├── assets/images/               # logo, hero, screenshots, og-image
│   ├── assets/favicon/              # favicon + PWA manifest
│   └── install.sh                   # served at leaf.ophelios.com/install.sh
├── resources/og-templates/site.html # source for the OG social card
├── scripts/generate-og-image.sh     # renders the OG card via headless Chrome
├── config.yml                       # site identity, sections, production URL
└── dist/                            # build output (not committed; GitHub Pages builds it)
```

Every other template, `app.css` and the docs scripts (search, sidebar, theme, copy-code, language switcher) come from the theme bundled in the `leaf` release pinned in `.github/workflows/pages.yml`. `layouts/docs.latte`, `layouts/landing.latte` and `partials/nav.latte` are the theme's files at that release (`app/Views/` of [`leaf`](https://github.com/zephyrus-framework/leaf) at the same tag) with only the change noted above: the site's own `<title>` comes from `partials/head.latte`, with a middle dot. When the pinned release moves, take these three files again from the new tag.

## Commands

```sh
leaf dev                              # live preview at http://localhost:8080
leaf build                            # rebuild dist/
scripts/generate-og-image.sh          # regenerate the OG social card
```

That's the whole workflow. No `composer install`, no PHP server to run manually.

## Writing content

Pages live under `content/{section}/{slug}.md`. Each file needs YAML front matter:

```yaml
---
title: Installation
order: 2
description: Optional; used in meta description and OG tags
---
```

- `title` — sidebar label and `<title>` tag
- `order` — position in the sidebar (lower = higher)
- `description` — auto-generated from the content if omitted

Sections (the top-level folders under `content/`) are defined in `config.yml`:

```yaml
leaf:
  sections:
    getting-started: "Getting Started"
    building-sites: "Building Sites"
    content-system: "Content"
    multi-locale: "Multi-locale"
    seo: "SEO"
    configuration: "Configuration"
    api-reference: "API Reference"
```

The YAML order drives the sidebar order.

## Customizing the theme

Drop a `.latte` file under `templates/` at the same relative path as the bundled view to override it, or a file under `public/` at the path of a bundled asset to replace it. The `leaf` binary merges both on top of the bundled theme at build time. An override replaces the whole file and stops following the theme, so keep overrides to what the site really changes (see Layout).

The docs styles (`app.css`: docs shell, sidebar, TOC, page content) come from the theme. `public/assets/css/landing.css` holds the landing-page-only tokens and components (scoped to `.landing`).

## Deployment

A push to `main` builds the site with the Leaf release pinned in `.github/workflows/pages.yml` and publishes it to GitHub Pages, at `leaf.ophelios.com`. The site is served as pure static files; no runtime PHP in production.

`dist/` is build output and is not versioned. Run `leaf build` locally only to preview the site before you push.

## OG image

`scripts/generate-og-image.sh` launches headless Chrome against `resources/og-templates/site.html` and writes the 1200×630 PNG to `public/assets/images/og-image.png`. Run it whenever the landing copy, logo, or hero changes. The generated file is committed; no runtime generation.

## Related repos

| Repo | Purpose |
|------|---------|
| [`leaf-cli`](https://github.com/zephyrus-framework/leaf-cli) | The `leaf` Go binary that builds this site |
| [`leaf`](https://github.com/zephyrus-framework/leaf) | Composer template (scaffolds embedded in the CLI) |
| [`leaf-core`](https://github.com/zephyrus-framework/leaf-core) | PHP library powering both tiers |

## License

MIT.
