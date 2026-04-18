---
title: Project Structure
order: 3
---

# Project Structure

A Leaf project follows a clear convention:

```
my-docs/
  app/
    Controllers/
      DocsController.php      # Routes and page rendering
    Models/Core/
      Application.php          # Extends Leaf\Kernel
    Views/
      layouts/docs.latte       # HTML wrapper for docs pages
      docs/page.latte           # Individual doc page template
      partials/                 # Reusable components (nav, sidebar, footer)
      404.latte                 # Error page
  bin/
    build.php                   # Static site build script
    router.php                  # Dev server entry point
  content/
    getting-started/
      introduction.md           # Markdown content pages
      installation.md
    guides/
      deployment.md
  public/
    index.php                   # Web application entry point
    assets/
      css/app.css               # All styles (light/dark theme)
      js/                       # Search, sidebar, copy-code, theme toggle
  config.yml                    # Site configuration
  dist/                         # Build output (deploy this)
```

## Key files

### `config.yml`

All site settings: project name, version, content paths, sections, and production URL. See [Configuration](/configuration/reference) for the full reference.

### `app/Models/Core/Application.php`

Your application class. Extends `Leaf\Kernel` and provides dependency injection for controllers:

```php
use Leaf\Kernel;

final class Application extends Kernel
{
    protected function createController(string $class): object
    {
        if ($class === DocsController::class) {
            return new DocsController(
                $this->contentLoader,
                $this->searchIndexBuilder,
                $this->leafConfig,
            );
        }
        return new $class();
    }
}
```

### `bin/build.php`

The build script. Uses `Leaf\BuildCommand` to run the standard pipeline:

```php
$app = new Application();
$command = new BuildCommand($app);
exit($command->run());
```

### `content/`

Where your Markdown documentation lives. Organized into sections (directories) with pages (`.md` files). Each file needs `title` and `order` front matter.

### `dist/`

Generated output from `composer build`. This is what you deploy. Contains static HTML, assets, sitemap, and robots.txt.
