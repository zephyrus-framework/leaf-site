---
title: Core Classes
order: 1
---

# Core Classes

Complete API reference for all classes in `zephyrus-framework/leaf-core`.

## Leaf\Kernel

Abstract application bootstrap. Extend this in your `Application` class.

```php
abstract class Kernel
{
    // Override for dependency injection
    protected function createController(string $class): object;

    // Override for custom controller discovery
    protected function registerControllers(Router $router): Router;

    // Public API
    public function run(): void;
    public function buildForStaticGeneration(): array;
    public function getConfig(): Configuration;
    public function getLeafConfig(): LeafConfig;
    public function getRenderEngine(): LatteEngine;
    public function getContentLoader(): ContentLoader;
    public function getTranslationExtension(): ?TranslationLatteExtension;
    public function getTranslator(): ?Translator;
}
```

**Protected properties** available in `createController()`:

- `$this->config` -- Zephyrus Configuration
- `$this->leafConfig` -- LeafConfig
- `$this->renderEngine` -- LatteEngine
- `$this->contentLoader` -- ContentLoader
- `$this->searchIndexBuilder` -- SearchIndexBuilder
- `$this->markdownParser` -- MarkdownParser
- `$this->translator` -- Translator (nullable)
- `$this->translationExtension` -- TranslationLatteExtension (nullable)

---

## Leaf\BuildCommand

Standard build pipeline with hooks.

```php
class BuildCommand
{
    public function __construct(Kernel $app);
    public function addPaths(array $paths): void;
    public function excludePatterns(array $patterns): void;
    public function onPostBuild(callable $callback): void;
    public function run(): int;  // Returns exit code
}
```

---

## Leaf\StaticSiteBuilder

Renders routes to static HTML files.

```php
class StaticSiteBuilder
{
    public function __construct(Application $app, Router $router);
    public function setOutputDirectory(string $path): void;
    public function setPublicDirectory(string $path): void;
    public function setBaseUrl(string $url): void;
    public function addPath(string $path): void;
    public function addPaths(array $paths): void;
    public function excludePatterns(array $patterns): void;
    public function setAssetExcludes(array $filenames): void;
    public function setLocales(array $locales, string $defaultLocale): void;
    public function setTranslationExtension(TranslationLatteExtension $ext): void;
    public function build(): StaticBuildResult;
}
```

---

## Leaf\StaticBuildResult

Immutable build result.

```php
final readonly class StaticBuildResult
{
    public int $pagesBuilt;
    public int $totalPaths;
    public float $elapsedMs;
    public array $errors;
    public string $outputDirectory;
    public array $builtPages;

    public function isSuccessful(): bool;
    public function summary(): string;
}
```

---

## Leaf\Content\ContentLoader

Loads and indexes Markdown content.

```php
class ContentLoader
{
    public function __construct(string $contentDirectory, MarkdownParser $parser, LeafConfig $config);
    public function getPage(string $section, string $slug): ?ParsedMarkdown;
    public function getSidebar(): array;
    public function getAllPages(): array;
    public function getPreviousPage(string $section, string $slug): ?array;
    public function getNextPage(string $section, string $slug): ?array;
    public function getFirstPageUrl(): string;
}
```

---

## Leaf\Content\MarkdownParser

Markdown to HTML with CommonMark + GFM.

```php
class MarkdownParser
{
    public function __construct();
    public function parse(string $markdown): ParsedMarkdown;
    public function extractFrontMatter(string $markdown): array;
}
```

---

## Leaf\Content\ParsedMarkdown

Parsed document value object.

```php
final readonly class ParsedMarkdown
{
    public string $html;
    public array $frontMatter;
    public array $toc;  // [{id, text, level}, ...]

    public function meta(string $key, mixed $default = null): mixed;
}
```

---

## Leaf\Seo\SitemapGenerator

XML sitemap generation.

```php
class SitemapGenerator
{
    public function __construct(string $baseUrl, string $outputDirectory);
    public function generate(array $pages): void;
    public function generateMultiLocale(array $pages, array $locales, string $defaultLocale): void;
}
```

---

## Leaf\Seo\RobotsGenerator

robots.txt generation.

```php
class RobotsGenerator
{
    public function __construct(string $outputDirectory);
    public function generate(?string $sitemapUrl = null, array $disallow = []): void;
}
```

---

## Leaf\DevRouter

Development server router.

```php
class DevRouter
{
    public function __construct(string $projectRoot);
    public function handle(): bool;
}
```

Handles static files, the locale prefix (a non-default locale from `supported_locales`, subtags included, is served from `content/<locale>/`), the live-reload endpoint (`/__dev/reload`), and defines the `DEV_SERVER` constant.

---

## Leaf\Config\LeafConfig

Typed configuration from the `leaf:` section in config.yml. See [Configuration Reference](/configuration/reference/) for all fields.

---

## Leaf\Localization\TranslationLatteExtension

Latte extension for multi-locale support.

```php
class TranslationLatteExtension extends Extension
{
    public function __construct(Translator $translator, string $defaultLocale, array $supportedLocales);
    public function getCurrentLocale(): string;
    public function setCurrentLocale(string $locale): void;
}
```

Registers `localize()` and `i18n()` template functions. Injects `$currentLocale`, `$defaultLocale`, `$supportedLocales` and `$localePrefix` template variables; a variable the render passes wins.
