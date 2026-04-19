---
title: Deployment
order: 3
---

# Deployment

After running `leaf build` (or `composer build`), the `dist/` directory contains a fully static site ready for deployment.

## Supported platforms

The output works with any static host:

- **Netlify** — connect your repo, set the build command and publish directory (`dist/`)
- **Vercel** — same approach, or deploy the `dist/` folder directly
- **GitHub Pages** — push the `dist/` folder, or use a GitHub Action
- **Cloudflare Pages** — connect your repo with `dist/` as the output directory
- **DigitalOcean App Platform** — point a Static Site component at the `dist/` directory
- **Any web server** — upload `dist/` to your document root

## Build commands per host

If your host runs the build for you, the command depends on which path you're on:

| Path | Build command | Dependencies your build server needs |
|------|---------------|---------------------------------------|
| Binary CLI | `leaf build` | The `leaf` binary (fetch via `curl` step) plus system PHP 8.4 |
| Composer | `composer install && composer build` | PHP 8.4 + Composer |

Example Netlify build command for the binary path:

```bash
curl -fsSL https://leaf.ophelios.com/install.sh | sh && leaf build
```

## Committing `dist/` to git

Alternative: build locally, commit `dist/`, let the host serve it without a build step. This is the simplest approach and works with every provider. Trade-off: every content change needs a rebuild + commit.

## Production URL

Set `production_url` in `config.yml` to enable sitemap and robots.txt generation:

```yaml
leaf:
  production_url: "https://docs.example.com"
```

This generates:

- `dist/sitemap.xml` with all page URLs and hreflang alternates
- `dist/robots.txt` with a reference to the sitemap

## Custom domain

After deploying, configure your DNS to point to your hosting provider. Most providers support custom domains with automatic HTTPS via Let's Encrypt.

## 404 handling

The build produces `dist/404.html`. Most static hosts serve it automatically for unmatched routes. If yours doesn't, configure it in the provider's settings.
