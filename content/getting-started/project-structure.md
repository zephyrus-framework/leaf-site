---
title: Project Structure
order: 3
---

# Project Structure

What your project looks like depends on which path you picked.

## Binary CLI

`leaf init` creates a minimal tree. You only see content, assets, optional templates, and config.

```
my-docs/
  content/
    getting-started/
      introduction.md
  locale/
    en/general.json       # theme strings, yours to edit
    fr/general.json
  public/
    assets/
      css/app.css
      js/
  templates/              # optional Latte overrides
  config.yml
  dist/                   # build output (deploy this)
```

Everything else — the framework, controllers, the build pipeline, the vendor graph — lives inside the `leaf` binary.

### `content/`

Your Markdown pages. Organized into sections (directories) with pages (`.md` files). Each file has `title` and `order` front matter.

### `public/`

Static assets copied verbatim to `dist/`. Put your logo, custom CSS overrides, fonts, and images here.

### `templates/` (optional)

Drop [Latte](https://latte.nette.org/) files here to override the bundled defaults. The binary merges your templates on top of the bundled theme at build time, file by file, at the same path. Examples:

- `templates/layouts/docs.latte` → overrides the bundled docs layout
- `templates/partials/nav.latte` → overrides the bundled nav
- `templates/landing.latte` → replaces the bundled landing page at `/`

Only `.latte` files are rendered: a `.php` or `.html` file under `templates/` is ignored.

To add standalone URLs like `/about` or `/contact`, drop Latte files under `templates/pages/`. See [Custom Pages](/content-system/custom-pages).

### `locale/`

The theme's interface strings (search, table of contents, pagination, 404), one JSON file per locale. Your keys are merged over the bundled ones, so a file can hold only the strings you change. See [Multi-Locale Setup](/multi-locale/setup/).

### `config.yml`

Site settings: name, version, sections, production URL. See [Configuration Reference](/configuration/reference).

### `dist/`

Generated output. Static HTML, CSS, JS, `sitemap.xml`, `robots.txt`, `search.json`. Deploy this.

## Composer template

`composer create-project zephyrus-framework/leaf my-docs` (or `leaf eject` on an existing CLI project) gives you the full Zephyrus application alongside the same `content/`, `public/`, `locale/` and `config.yml`:

```
my-docs/
  app/
    Controllers/
      DocsController.php      # Routes and page rendering
    Models/Core/
      Application.php         # Extends Leaf\Kernel
    Views/
      layouts/docs.latte      # HTML wrapper for docs pages
      docs/page.latte         # Individual doc page template
      partials/               # Reusable components (nav, sidebar, footer)
      404.latte               # Error page
  bin/
    build.php                 # Static site build script
    router.php                # Dev server entry point
  content/                    # same as CLI
  locale/                     # theme strings, the full catalogue (nothing merged in)
  public/                     # same as CLI
  templates/                  # not read by composer build: overrides go in app/Views/
  config.yml                  # same as CLI
  vendor/                     # Composer dependencies
  composer.json
  dist/
```

### Key files unique to the Composer path

#### `app/Models/Core/Application.php`

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

#### `bin/build.php`

The build script. A file you own and can modify:

```php
$app = new Application();
$command = new BuildCommand($app);
exit($command->run());
```

Add custom paths, hook into the pipeline, post-process output. See the [BuildCommand](/building-sites/build-command) reference.

#### `app/Controllers/`

Where you add custom routes. Each controller is a Zephyrus class with `#[Get]`, `#[Post]`, etc. attribute-routed endpoints.

## Which files are shared between the two paths?

Everything under `content/`, `public/`, `locale/` and `config.yml` is identical. `templates/` is a CLI feature: on the Composer path, edit `app/Views/` instead. You can move a project between paths via `leaf eject` (CLI → Composer) or by deleting `app/`, `bin/`, `composer.json`, and `vendor/` (Composer → CLI).
