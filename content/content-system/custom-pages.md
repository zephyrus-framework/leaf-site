---
title: Custom Pages
order: 4
description: Standalone URLs like /about, /contact, or /pricing rendered from Latte templates.
---

# Custom Pages

Docs and blog posts live under `content/` as Markdown. When you need a standalone page at a specific URL (`/about`, `/contact`, `/pricing`, whatever), drop a [Latte](https://latte.nette.org/) file under `templates/pages/` and Leaf will render it.

```
templates/
  pages/
    about.latte       → /about/
    contact.latte     → /contact/
    pricing.latte     → /pricing/
```

That's it. `leaf build` (or `composer build`) picks up every `.latte` file in that directory, registers the route, and renders each one with the full template context.

## A minimal page

```latte
{layout '../layouts/landing.latte'}

{block content}
<main class="container mx-auto px-6 py-24">
    <h1 class="text-4xl font-bold">{$pageTitle}</h1>
    <p class="mt-4 text-muted">
        This is the about page, rendered from <code>templates/pages/about.latte</code>.
    </p>
</main>
{/block}
```

You get the same template globals as any other view: `$leafName`, `$leafVersion`, `$leafAuthor`, `$leafGithubUrl`, `$leafBaseUrl`, `$leafProductionUrl`, and all the locale variables when multi-locale is enabled.

## Template variables

Every page renders with:

| Variable | What |
|---|---|
| `$title` | `"<slug in Title Case> · <leafName>"` (useful for `<title>`) |
| `$pageTitle` | `<slug>` humanized (`about-us` → `About Us`) |
| `$pagePath` | `/about`, for hreflang/canonical helpers |
| `$leaf*` | All standard [Latte globals](/configuration/reference) |

Override any of them yourself in the template if the defaults don't fit.

## Naming rules

The file name becomes the URL slug. Leaf accepts names matching `[a-z0-9][a-z0-9-]*`:

- `about.latte` → `/about/`  ✓
- `pricing-plans.latte` → `/pricing-plans/`  ✓
- `2024-roadmap.latte` → routes fine, though numeric-leading is unusual  ✓
- `About.latte` → stops the whole build: `Page "About.latte" cannot be served: page file names may only contain lowercase letters, digits and hyphens, and must not start with a hyphen. Rename it to "about.latte".`
- `partial.latte` inside a subdirectory (`pages/marketing/partial.latte`) → ignored (only top-level files are exposed as routes)

Rename to fit the rules, and the route snaps into place.

## Layouts and partials

Pages extend layouts exactly like any other view. Paths in `{layout}` and `{include}` resolve from the page's own folder, `pages/`, hence the `../`:

```latte
{layout '../layouts/landing.latte'}

{block content}
<section>…</section>
{/block}
```

Need a nav, footer, or hero partial? Use `{include '../partials/nav.latte'}`, as the bundled layouts do. Or author your own partial under `templates/partials/<name>.latte` and reference it.

## Binary CLI vs Composer

Only the `leaf` binary maps `templates/` onto `app/Views/`: at build time it merges your `templates/pages/` into the bundled `app/Views/pages/`, with no further wiring. On the Composer tier, `composer build` and `composer dev` render `app/Views/` and ignore `templates/`, so pages go in `app/Views/pages/`. `leaf eject` leaves `templates/` where it is: move its files into `app/Views/` yourself.

If you ejected to the Composer tier and want full control over `PagesController`, it's a standard Zephyrus controller in `app/Controllers/PagesController.php`: inject services, swap the view resolution, add caching, whatever you need.

## Pasting plain HTML

Only `.latte` files become pages. A `.php` or `.html` file in `templates/pages/` is skipped without a word: the build succeeds and the URL does not exist.

To ship markup exactly as you pasted it, save it as a `.latte` file and wrap it in `{syntax off}`, so Latte leaves every brace alone:

```latte
{syntax off}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About</title>
    <style>body { font-family: system-ui; }</style>
</head>
<body>
    <h1>About</h1>
</body>
</html>
{/syntax}
```

Saved as `templates/pages/about.latte`, it builds to `dist/about/index.html` as written: no layout, no variables.

## When to eject

Custom pages cover the 90% case: static marketing pages, a contact form that posts to a third party, a pricing page with Stripe checkout button, legal text. If you need something the template doesn't (form submission handlers, API endpoints, custom middleware, database queries on the dynamic side), that's when `leaf eject` kicks in and you get the full Zephyrus toolkit.
