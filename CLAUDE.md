# CLAUDE.md: leaf.ophelios.com

## What is this

The docs and landing site for Zephyrus Leaf, published at [leaf.ophelios.com](https://leaf.ophelios.com). This repo dogfoods the Binary CLI tier: it has no `app/`, `bin/`, `vendor/`, or `composer.json`. Everything user-authored lives in `content/`, `templates/`, `public/`, and `config.yml`. The `leaf` CLI binary handles the build.

## Ecosystem

| Repo | Purpose |
|---|---|
| [`zephyrus-leaf-cli`](https://github.com/ophelios-studio/zephyrus-leaf-cli) | The `leaf` Go binary that builds this site |
| [`zephyrus-leaf`](https://github.com/ophelios-studio/zephyrus-leaf) | Composer template (scaffolds embedded in the CLI) |
| [`zephyrus-leaf-core`](https://github.com/ophelios-studio/zephyrus-leaf-core) | PHP library powering both tiers |

## Layout

```
.
├── content/           # Markdown docs, organized by section
├── templates/         # Overrides for the bundled theme
│   ├── landing.latte  # Custom landing with binary/composer tabs
│   ├── layouts/       # Custom docs + landing layouts
│   └── partials/      # Custom head (SEO meta, OG) and nav
├── public/            # Static assets copied verbatim to dist/
│   ├── assets/css/    # landing.css + docs app.css
│   ├── assets/js/     # landing.js + docs search/sidebar/theme/copy-code
│   ├── assets/images/ # logo, hero, screenshots, og-image
│   ├── assets/favicon/
│   └── install.sh     # served at leaf.ophelios.com/install.sh
├── resources/
│   └── og-templates/  # HTML template for OG card generation
├── scripts/
│   └── generate-og-image.sh  # Chrome-headless render of public/assets/images/og-image.png
├── config.yml         # Site config (leaf: section drives everything)
└── dist/              # Build output; committed and served by DigitalOcean
```

## Common commands

```sh
leaf dev                         # live preview at http://localhost:8080
leaf build                       # rebuild dist/
scripts/generate-og-image.sh     # regenerate the OG social card
```

## Deployment

`dist/` is committed. DigitalOcean's App Platform auto-deploys on push to `main`. Serves statically; no runtime PHP in production.

## Design rules

- **Dark theme is primary, light theme is supported.** Styles live in `public/assets/css/`. Landing has its own file (`landing.css`) that scopes tokens locally.
- **Template overrides must match the bundled path.** `templates/partials/nav.latte` overrides `app/Views/partials/nav.latte` in the bundled framework. Same for layouts, partials, and the landing.
- **Never use em dashes (U+2014) in any output or content.** User rule.
- **Commit messages: semantic prefix, single line, no co-author.**
- **Rebuild `dist/` before committing whenever templates, content, or assets change.** CI doesn't run `leaf build` (static deploy).
- **`.claude/` is agent-private, gitignored, never committed.**
