# leaf.ophelios.com

The landing and documentation site for [Zephyrus Leaf](https://github.com/ophelios-studio/zephyrus-leaf-cli), published at [leaf.ophelios.com](https://leaf.ophelios.com).

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
│   ├── landing.latte                # Custom landing with binary/composer tabs
│   ├── layouts/docs.latte           # Custom docs wrapper
│   ├── layouts/landing.latte        # Custom landing wrapper
│   ├── partials/head.latte          # SEO meta + OG tags
│   └── partials/nav.latte           # Site nav (brand, theme toggle)
├── public/
│   ├── assets/css/                  # app.css (docs) + landing.css
│   ├── assets/js/                   # landing.js + search/sidebar/theme/copy-code
│   ├── assets/images/               # logo, hero, screenshots, og-image
│   ├── assets/favicon/              # favicon + PWA manifest
│   └── install.sh                   # served at leaf.ophelios.com/install.sh
├── resources/og-templates/site.html # source for the OG social card
├── scripts/generate-og-image.sh     # renders the OG card via headless Chrome
├── config.yml                       # site identity, sections, production URL
└── dist/                            # build output (committed; DO serves this)
```

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

Drop any file under `templates/` at the same relative path as the bundled view to override it. Examples:

- `templates/partials/nav.latte` — overrides the site nav
- `templates/layouts/docs.latte` — overrides the docs page wrapper
- `templates/landing.latte` — overrides the home page

The `leaf` binary merges your templates on top of the bundled theme at build time. You can use `.latte`, `.php`, or `.html` (HTML is passed through, no interpolation).

Styles live in `public/assets/css/`:

- `app.css` — docs shell, sidebar, TOC, page content
- `landing.css` — landing-page-only tokens and components (scoped to `.landing`)

## Deployment

`dist/` is committed to `main`. DigitalOcean's App Platform auto-deploys on push. The site is served as pure static files; no runtime PHP in production.

Before committing, rebuild:

```sh
leaf build
git add dist/ <your other changes>
git commit -m "feat: <change>"
git push
```

## OG image

`scripts/generate-og-image.sh` launches headless Chrome against `resources/og-templates/site.html` and writes the 1200×630 PNG to `public/assets/images/og-image.png`. Run it whenever the landing copy, logo, or hero changes. The generated file is committed; no runtime generation.

## Related repos

| Repo | Purpose |
|------|---------|
| [`zephyrus-leaf-cli`](https://github.com/ophelios-studio/zephyrus-leaf-cli) | The `leaf` Go binary that builds this site |
| [`zephyrus-leaf`](https://github.com/ophelios-studio/zephyrus-leaf) | Composer template (scaffolds embedded in the CLI) |
| [`zephyrus-leaf-core`](https://github.com/ophelios-studio/zephyrus-leaf-core) | PHP library powering both tiers |

## License

MIT.
