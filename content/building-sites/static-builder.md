---
title: StaticSiteBuilder
order: 2
---

# StaticSiteBuilder

`Leaf\StaticSiteBuilder` is the lower-level class that renders routes into static HTML. Most projects use `BuildCommand` which wraps this class, but you can use it directly for full control.

## Direct usage

```php
use Leaf\StaticSiteBuilder;

[$application, $router] = $app->buildForStaticGeneration();

$builder = new StaticSiteBuilder($application, $router);
$builder->setOutputDirectory('/path/to/dist');
$builder->setPublicDirectory('/path/to/public');
$builder->setBaseUrl('http://localhost');

// Add parameterized routes
$builder->addPath('/blog/my-post');
$builder->addPaths(['/blog/post-1', '/blog/post-2']);

// Exclude paths
$builder->excludePatterns(['#^/api/#']);

// Build
$result = $builder->build();

echo $result->summary();
// "Built 15/15 pages in 234.5ms [OK] -> /path/to/dist"
```

## Multi-locale builds

```php
$builder->setLocales(['en', 'fr', 'ar'], 'en');
$builder->setTranslationExtension($translationExtension);
$result = $builder->build();
```

When locales are configured:

- The **default locale** builds to the root directory (`dist/`)
- Other locales build to subdirectories (`dist/fr/`, `dist/ar/`)
- Assets are copied once (shared across locales)
- Each locale renders every page with the appropriate translations

## StaticBuildResult

The `build()` method returns an immutable result object:

```php
$result->pagesBuilt;      // int: pages successfully rendered
$result->totalPaths;       // int: total paths attempted
$result->elapsedMs;        // float: build duration in milliseconds
$result->errors;           // array: error messages
$result->outputDirectory;  // string: where files were written
$result->builtPages;       // array: list of built page paths
$result->isSuccessful();   // bool: true if no errors
$result->summary();        // string: formatted summary
```

The `builtPages` array contains locale-agnostic paths (e.g., `["/", "/blog", "/blog/my-post"]`), useful for generating sitemaps.

## Asset handling

Static assets from `publicDirectory` are recursively copied to `outputDirectory`. By default, `index.php` and `.htaccess` are excluded. Customize with:

```php
$builder->setAssetExcludes(['index.php', '.htaccess', '.env']);
```
