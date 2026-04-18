---
title: BuildCommand
order: 1
---

# BuildCommand

`Leaf\BuildCommand` is the standard build pipeline. It handles everything from rendering pages to generating SEO files.

## Basic usage

```php
// bin/build.php
define('ROOT_DIR', dirname(__DIR__));
require ROOT_DIR . '/vendor/autoload.php';

use App\Models\Core\Application;
use Leaf\BuildCommand;

$app = new Application();
$command = new BuildCommand($app);
exit($command->run());
```

Run it with:

```bash
composer build
# or
php bin/build.php
```

## What the pipeline does

1. Discovers all GET routes from your controllers
2. Scans `content/` for Markdown files and adds their paths
3. Renders each page through the full Zephyrus application stack
4. Copies static assets from `public/` to `dist/`
5. Moves `/404/index.html` to `/404.html`
6. Generates `search.json` for client-side search
7. Creates a root redirect (single-locale) or builds default locale to root (multi-locale)
8. Generates `sitemap.xml` and `robots.txt` (if `production_url` is configured)
9. Runs any registered post-build callbacks

## Adding custom paths

For parameterized routes that the router can't auto-discover (like `/blog/{slug}`), add them explicitly:

```php
$command = new BuildCommand($app);

$command->addPaths([
    '/blog',
    '/blog/my-first-post',
    '/blog/another-post',
]);

exit($command->run());
```

## Excluding paths

To exclude routes from the build:

```php
$command->excludePatterns([
    '#^/api/#',        // Exclude API routes
    '#^/admin#',       // Exclude admin pages
]);
```

The pipeline always excludes `/search.json` and `/` by default (the root is handled separately).

## Post-build hooks

Add custom steps that run after the standard pipeline:

```php
$command->onPostBuild(function ($result, $outputDir) {
    // Generate OG images
    passthru('node bin/generate-og-images.js');

    // Optimize images
    passthru('npx imagemin dist/assets/images/* --out-dir=dist/assets/images');

    // Custom sitemap additions
    echo "Post-build complete!" . PHP_EOL;
});
```

The callback receives:
- `$result` -- a `StaticBuildResult` with `pagesBuilt`, `totalPaths`, `errors`, `builtPages`
- `$outputDir` -- absolute path to the output directory

## Build output

A successful build produces:

```
dist/
  index.html              # Root page (or locale redirect)
  404.html                # Error page
  search.json             # Search index
  sitemap.xml             # XML sitemap (if production_url set)
  robots.txt              # Robots file (if production_url set)
  assets/                 # CSS, JS, images
  getting-started/
    introduction/
      index.html           # Each page becomes a directory with index.html
```
