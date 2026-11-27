---
title: BuildCommand
order: 1
---

# BuildCommand

`Leaf\BuildCommand` is the build pipeline under the hood. It handles everything from rendering pages to generating SEO files. Both `leaf build` (binary CLI) and `composer build` (Composer template) call it.

## Running a build

### Binary CLI

```bash
leaf build
```

That's it. No PHP code to write, no `bin/build.php` to maintain.

### Composer template

The template ships a `bin/build.php` that you own:

```bash
composer build
# or
php bin/build.php
```

In a project created from the 1.0 template, or one that took over its compiled stylesheet, `composer build` first compiles the theme's Tailwind stylesheet, `public/assets/css/tailwind.css`, from your templates, the `class` attributes of your Markdown pages and your scripts (`composer css`, which runs `bin/tailwind.sh`), then runs `php bin/build.php`. `php bin/build.php` alone builds the pages with the stylesheet as it stands. The first compile downloads the standalone Tailwind CSS CLI from GitHub, so it needs `sh`, `curl` or `wget`, and `sha256sum` or `shasum`.

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

Edit this file to customize the build.

## What the pipeline does

1. Discovers all GET routes from your controllers (Composer path) or scaffold routes (CLI path)
2. Scans `content/` for Markdown files and adds their paths
3. Renders each page through the full Zephyrus application stack
4. Copies static assets from `public/` to `dist/`
5. Moves `/404/index.html` to `/404.html`
6. Generates `search.json` for client-side search
7. Creates a root redirect (single-locale) or builds default locale to root (multi-locale). If a `GET /` route exists (custom landing), it's rendered instead of the redirect.
8. Generates `sitemap.xml` and `robots.txt` (if `production_url` is configured)
9. Runs any registered post-build callbacks

## Customizing (Composer path only)

If you're on the CLI path, skip this section: the `leaf` binary drives a stock pipeline. To customize, `leaf eject` first.

### Adding custom paths

For parameterized routes the router can't auto-discover (like `/blog/{slug}`):

```php
$command = new BuildCommand($app);

$command->addPaths([
    '/blog',
    '/blog/my-first-post',
    '/blog/another-post',
]);

exit($command->run());
```

### Excluding paths

```php
$command->excludePatterns([
    '#^/api/#',        // Exclude API routes
    '#^/admin#',       // Exclude admin pages
]);
```

`/search.json` is always excluded (generated separately). `/` is excluded when no custom `GET /` route exists (handled by the redirect/default-locale logic).

### Post-build hooks

```php
$command->onPostBuild(function ($result, $outputDir) {
    // Generate OG images
    passthru('node bin/generate-og-images.js');

    // Optimize images
    passthru('npx imagemin dist/assets/images/* --out-dir=dist/assets/images');

    echo "Post-build complete!" . PHP_EOL;
});
```

The callback receives:

- `$result`: a `StaticBuildResult` with `pagesBuilt`, `totalPaths`, `errors`, `builtPages`
- `$outputDir`: absolute path to the output directory

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
      index.html          # Each page becomes a directory with index.html
```
