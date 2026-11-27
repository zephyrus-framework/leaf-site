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
│   ├── layouts/home.latte           # Home wrapper: landing.css, landing.js and Prism, no theme nav or footer
│   └── partials/head.latte          # The theme's head plus favicons, canonical, OG tags, description fallback
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

Every other template, `app.css`, the compiled Tailwind stylesheet `tailwind.css` and the docs scripts (search, sidebar, theme, copy-code, tables, language switcher) come from the theme bundled in the `leaf` release pinned in `.github/workflows/pages.yml` (v1.0.0). Besides the home page (`landing.latte`, on the site's own `layouts/home.latte`), `partials/head.latte` is the only theme file the site overrides, for what the theme's head lacks: favicons and the web manifest, a canonical URL and `og:url`, the `og:image` social card with a large Twitter card, and the site description on pages that set none. From the font links down it is the theme's head as is, with no Tailwind script: `tailwind.css` follows `app.css`. The docs header shows the Leaf logo through `leaf.logo` in `config.yml`, with no nav override. When the pinned release moves (`LEAF_VERSION` in `.github/workflows/pages.yml`), take over what the theme's `CHANGELOG.md` lists for `partials/head.latte` and `layouts/landing.latte` (whose Prism scripts `layouts/home.latte` repeats), comparing them with `app/Views/` of [`leaf`](https://github.com/zephyrus-framework/leaf) at the new tag, and set `leaf.version` in `config.yml` (shown in the header badge and the home footer) to the same version, without the `v`.

The two docs previews in the hero (`screenshot-light.png` and `screenshot-dark.png`) are captures of `/getting-started/introduction/` at 1440×900 and twice the pixel density, taken with the header version badge hidden so that they do not go stale at the next release.

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

- `title`: sidebar label and `<title>` tag
- `order`: position in the sidebar (lower = higher)
- `description`: auto-generated from the content if omitted

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

The docs styles (`app.css`: docs shell, sidebar, TOC, page content, and the Tailwind classes compiled in `tailwind.css`) come from the theme. `public/assets/css/landing.css` holds the landing-page-only tokens and components (scoped to `.landing`), and is linked from `layouts/home.latte` only. The site loads no Tailwind script, so a Tailwind class the theme's `tailwind.css` lacks has no style: give it a rule in `landing.css` for the home page, or in a stylesheet linked from `partials/head.latte` for the docs pages.

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
