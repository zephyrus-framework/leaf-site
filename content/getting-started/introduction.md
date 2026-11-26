---
title: Introduction
order: 1
---

# Introduction

Zephyrus Leaf is a static site generator for documentation, landings, and blogs. You author Markdown (and optionally templates in [Latte](https://latte.nette.org/)). Leaf produces deployable static HTML in one command.

There are two ways to use Leaf. Both share the same core library.

| Path | Who it's for | What you run |
|------|--------------|--------------|
| **Binary CLI** | Most people. One binary, no Composer project; building needs PHP 8.4. | `leaf init`, `leaf dev`, `leaf build` |
| **Composer** | PHP developers who want controllers, packages, or full build-script control. | `composer create-project`, `composer dev`, `composer build` |

You can start with the CLI and switch to Composer later via `leaf eject`. One-way, documented.

## What you get

- **Markdown-powered pages** with front matter, GFM tables, and syntax highlighting
- **Live-reload dev server** with change detection on content, templates, and assets
- **One-command builds** that produce static HTML in `dist/`
- **Full-text search** (client-side, zero backend)
- **Multi-locale support** with a language switcher, per-locale search, and `hreflang` alternates in the sitemap
- **SEO out of the box** (`sitemap.xml`, `robots.txt`, OpenGraph tags)
- **Light and dark themes** with system-preference awareness
- **Latte templates** you can override file by file

## Quick start (binary CLI, recommended)

```bash
curl -fsSL https://leaf.ophelios.com/install.sh | sh
leaf init my-docs
cd my-docs
leaf dev      # live reload on http://localhost:8080
leaf build    # writes dist/, ready to deploy anywhere static
```

## Quick start (Composer)

For teams who want to extend with PHP:

```bash
composer create-project zephyrus-framework/leaf my-docs
cd my-docs
composer dev
composer build
```

## Architecture

| Package | Type | Purpose |
|---------|------|---------|
| `zephyrus-framework/leaf-core` | Library | Static builder, content parser, SEO generators, Kernel |
| `zephyrus-framework/leaf` | Composer template | Views, controllers, config, assets, sample content |
| `zephyrus-framework/leaf-cli` | Go binary | Wraps everything above, ships as one executable |

The CLI bundles the framework and scaffolds inside the binary. The Composer template exposes the same framework as a regular PHP project you can extend. Updates to `leaf-core` flow to both paths.

## Next steps

- [Installation](/getting-started/installation) — detailed setup for either path
- [Project Structure](/getting-started/project-structure) — what the CLI scaffolds, and what Composer gives you
- [CLI Reference](/getting-started/cli-reference) — every `leaf` subcommand
