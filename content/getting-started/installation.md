---
title: Installation
order: 2
---

# Installation

## Requirements

- **PHP 8.4+** with `intl` and `mbstring` extensions
- **Composer** 2.x
- **Node.js** (optional, only for OG image generation)

## Create a new project

```bash
composer create-project zephyrus-framework/leaf my-docs
cd my-docs
```

This gives you a ready-to-use documentation site with sample content, dark/light theme, search, and live-reload.

## Development server

```bash
composer dev
```

This starts PHP's built-in server at `http://localhost:8080` with:

- **Live-reload** -- the page refreshes automatically when you edit templates, CSS, JS, or content
- **Locale prefix handling** -- URLs like `/fr/getting-started/intro` are routed correctly
- **Static file serving** -- assets from `public/` are served directly

## Build for production

```bash
composer build
```

This generates a fully static site in the `dist/` directory. The output is plain HTML, CSS, and JS that can be deployed to any static hosting provider: Netlify, Vercel, GitHub Pages, Cloudflare Pages, DigitalOcean, or a simple web server.

## Using in an existing project

If you want to add Leaf's build tools to an existing Zephyrus project:

```bash
composer require zephyrus-framework/leaf-core
```

Then extend `Leaf\Kernel` in your Application class and use `Leaf\BuildCommand` in your build script. See the [BuildCommand](/building-sites/build-command) documentation.
