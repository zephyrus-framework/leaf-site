---
title: Sitemap & Robots
order: 1
---

# Sitemap & Robots

Leaf automatically generates `sitemap.xml` and `robots.txt` when a `production_url` is configured.

## Enable SEO generation

Set the production URL in `config.yml`:

```yaml
leaf:
  production_url: "https://docs.example.com"
```

On the next build, the pipeline generates:

- `dist/sitemap.xml` -- XML sitemap with all pages
- `dist/robots.txt` -- allows all crawlers, references the sitemap

## Sitemap format

### Single-locale

For single-locale sites, the sitemap lists all pages:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://docs.example.com/</loc></url>
  <url><loc>https://docs.example.com/getting-started/installation/</loc></url>
</urlset>
```

### Multi-locale

For multi-locale sites, each page gets entries for all locales with `xhtml:link` hreflang alternates:

```xml
<url>
  <loc>https://example.com/</loc>
  <xhtml:link rel="alternate" hreflang="en" href="https://example.com/"/>
  <xhtml:link rel="alternate" hreflang="fr" href="https://example.com/fr/"/>
  <xhtml:link rel="alternate" hreflang="x-default" href="https://example.com/"/>
</url>
```

The default locale URLs have no prefix (at root). Other locales get `/{locale}/` prefixes.

## Robots.txt

The generated `robots.txt` allows all crawlers:

```
User-agent: *
Allow: /

Sitemap: https://docs.example.com/sitemap.xml
```

## Submitting to search engines

After deploying, submit your sitemap URL in:

- **Google Search Console** -- add your sitemap at `https://search.google.com/search-console`
- **Bing Webmaster Tools** -- submit at `https://www.bing.com/webmasters`

## Custom generation

If you need more control, use the generators directly:

```php
use Leaf\Seo\SitemapGenerator;
use Leaf\Seo\RobotsGenerator;

$sitemap = new SitemapGenerator('https://example.com', $outputDir);
$sitemap->generateMultiLocale($pages, ['en', 'fr'], 'en');

$robots = new RobotsGenerator($outputDir);
$robots->generate('https://example.com/sitemap.xml', ['/admin']);
```
