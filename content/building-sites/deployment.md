---
title: Deployment
order: 4
---

# Deployment

After running `leaf build` (or `composer build`), the `dist/` directory contains a fully static site ready for deployment.

## Supported platforms

The output works with any static host:

- **Netlify**: connect your repo, set the build command and publish directory (`dist/`)
- **Vercel**: same approach, or deploy the `dist/` folder directly
- **GitHub Pages**: build in a GitHub Action with a pinned release (see below), or push the `dist/` folder
- **Cloudflare Pages**: connect your repo with `dist/` as the output directory
- **DigitalOcean App Platform**: point a Static Site component at the `dist/` directory
- **Any web server**: upload `dist/` to your document root

The bundled theme ships its Tailwind CSS classes compiled, in `assets/css/tailwind.css`, and loads no Tailwind script. When the page opens, it loads Prism from `cdnjs.cloudflare.com` (checked against its Subresource Integrity hash) and its fonts from Google Fonts. A Content Security Policy on your host needs at least the one in the theme's README, [Content Security Policy](https://github.com/zephyrus-framework/leaf/blob/v1.0.0/README.md#content-security-policy):

```text
default-src 'self'; script-src 'self' https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/ 'unsafe-inline'; style-src 'self' https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/ https://fonts.googleapis.com 'unsafe-inline'; font-src https://fonts.gstatic.com
```

The README also gives the hashes that can replace the `'unsafe-inline'` of `script-src`, and what to add when a site loads Tailwind from its CDN.

## Build commands per host

If your host runs the build for you, the command depends on which path you're on:

| Path | Build command | Dependencies your build server needs |
|------|---------------|---------------------------------------|
| Binary CLI | `leaf build` | The `leaf` binary (fetch via `curl` step) plus PHP 8.4 with `intl`, `mbstring` and `tokenizer` |
| Composer | `composer install && composer build` | PHP 8.4 + Composer, plus what `bin/tailwind.sh` needs to compile the Tailwind stylesheet: `sh`, `curl` or `wget`, `sha256sum` or `shasum`, and access to GitHub on the first run, to download the standalone Tailwind CSS CLI (checked against the SHA-256 pinned in `bin/tailwind.sh`) |

Example Netlify build command for the binary path:

```bash
curl -fsSL https://leaf.ophelios.com/install.sh | sh && leaf build
```

## GitHub Pages with a pinned release

Build in CI with a fixed CLI version, so the theme and the pipeline change only when you bump that version. The workflow downloads the release binary, checks it against the SHA-256 published in the release's `checksums.txt`, builds, and hands `dist/` to Pages. The core steps:

```yaml
env:
  LEAF_VERSION: v1.0.0

jobs:
  build:
    runs-on: ubuntu-24.04
    steps:
      # actions/checkout, then shivammathur/setup-php with php-version: '8.4'
      # and extensions: dom, intl, mbstring, sodium, pdo
      - name: Install pinned Leaf release
        shell: bash
        run: |
          curl --fail --silent --show-error --location --retry 3 \
            "https://github.com/zephyrus-framework/leaf-cli/releases/download/${LEAF_VERSION}/leaf-linux-amd64" \
            --output "$RUNNER_TEMP/leaf"
          printf '%s  %s\n' \
            '06f75047b74bc05f030bc683674d141e95599379a1996a1d55d7ad347b9c5a2b' \
            "$RUNNER_TEMP/leaf" | sha256sum --check --strict
          chmod +x "$RUNNER_TEMP/leaf"

      - name: Build the site
        env:
          APP_DEBUG: 'false'
        run: |
          "$RUNNER_TEMP/leaf" build
          test -s dist/index.html
          test -s dist/404.html

      # then actions/upload-pages-artifact with path: dist
```

A second job publishes the artifact with `actions/deploy-pages` and needs the `pages: write` and `id-token: write` permissions. In the repository settings, set the Pages source to **GitHub Actions**. This documentation site deploys this way: its [`pages.yml`](https://github.com/zephyrus-framework/leaf-site/blob/main/.github/workflows/pages.yml) is a complete workflow to copy.

To upgrade, change `LEAF_VERSION` and the checksum together: take the `leaf-linux-amd64` line of the new release's `checksums.txt`. A wrong checksum stops the job before anything is built.

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

On a multi-locale site, each other locale has its own 404 page too, at `dist/<locale>/404.html`. A host that serves only the root `404.html`, such as GitHub Pages, gets the default locale's page for a missing `/fr/...` URL, and its script sends the visitor to `/fr/404.html`. See [Multi-Locale Setup](/multi-locale/setup/#404-pages).
