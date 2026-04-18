---
title: Deployment
order: 3
---

# Deployment

After running `composer build`, the `dist/` directory contains a fully static site ready for deployment.

## Supported platforms

The output works with any static hosting provider:

- **Netlify** -- connect your repo, set build command to `composer build`, publish directory to `dist/`
- **Vercel** -- same approach, or deploy the `dist/` folder directly
- **GitHub Pages** -- push the `dist/` folder or use a GitHub Action
- **Cloudflare Pages** -- connect your repo with `dist/` as output directory
- **DigitalOcean App Platform** -- point to the `dist/` directory
- **Any web server** -- upload `dist/` to your server's document root

## Committing dist/

You can choose to either:

1. **Commit `dist/` to git** -- the simplest approach. Your hosting platform serves the files directly without running a build step.
2. **Build on deploy** -- add `composer build` as a build command in your hosting platform's settings. Requires PHP on the build server.

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

The build produces a `dist/404.html` file. Most static hosting providers serve this automatically for unmatched routes. If yours doesn't, configure it in your provider's settings.
