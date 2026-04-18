---
title: Introduction
order: 1
---

# Introduction

Zephyrus Leaf is a static site generator built on the [Zephyrus PHP Framework](https://github.com/ophelios-studio/zephyrus). It turns your Markdown content and Latte templates into a fast, deployable static site with one command.

## What you get

- **Markdown-powered pages** with front matter, GFM tables, and syntax highlighting
- **Live-reload** during development -- edit a file, see changes instantly
- **One-command static builds** -- run `composer build` to generate a `dist/` folder
- **Full-text search** -- client-side fuzzy search across all your pages
- **Multi-locale support** -- build in multiple languages with the default locale at root
- **SEO out of the box** -- automatic sitemap.xml, robots.txt, and hreflang tags
- **Light and dark themes** -- system-preference aware with a toggle
- **Built on Zephyrus** -- the full framework is available if you need controllers, middleware, or custom logic

## Architecture

Leaf has two packages:

| Package | Type | Purpose |
|---------|------|---------|
| `zephyrus-framework/leaf-core` | Library | Static builder, content parser, SEO generators, Kernel |
| `zephyrus-framework/leaf` | Template | Views, controllers, config, assets, sample content |

When you create a project from the template, you get a working documentation site. The core library handles the build pipeline. When the core is updated, all projects benefit via `composer update`.

## Quick start

```bash
composer create-project zephyrus-framework/leaf my-docs
cd my-docs
composer dev
```

Open `http://localhost:8080` and you'll see your documentation site with live-reload enabled.

## Next steps

- [Installation](/getting-started/installation) -- detailed setup instructions
- [Project Structure](/getting-started/project-structure) -- understand the file layout
