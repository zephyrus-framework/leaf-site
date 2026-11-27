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

That's it. `leaf build` picks up every `.latte` file in that directory, registers the route, and renders each one with the full template context. On the Composer tier, `composer build` reads `app/Views/pages/` instead.

## A minimal page

```latte
{layout '../layouts/landing.latte'}

{block content}
<main id="main-content" tabindex="-1" class="max-w-4xl mx-auto px-6 py-32">
    <h1 class="text-5xl font-bold text-bright leading-tight mb-6">{$pageTitle}</h1>
    <p class="text-muted">
        This is the about page, rendered from <code>templates/pages/about.latte</code>.
    </p>
</main>
{/block}
```

Give the `<main>` the id `main-content`: it is the target of the theme's "Skip to content" link, which the theme hides on a page without it. Its top padding (`py-32`) clears the fixed navigation bar.

You get the same template globals as any other view: `$leafName`, `$leafVersion`, `$leafAuthor`, `$leafGithubUrl`, `$leafBaseUrl`, `$leafProductionUrl`, and all the locale variables when multi-locale is enabled.

## Template variables

Every page renders with:

| Variable | What |
|---|---|
| `$title` | `<slug>` humanized, as `$pageTitle`: the theme's `head.latte` writes `<title>` as `About Us · <leafName>` |
| `$pageTitle` | `<slug>` humanized (`about-us` → `About Us`) |
| `$pagePath` | `/about`, for hreflang/canonical helpers |
| `$leaf*` | All standard [Latte globals](/configuration/reference/) |

Override any of them yourself in the template if the defaults don't fit.

## Styling a page

The theme ships its Tailwind CSS classes compiled, in `assets/css/tailwind.css`, and loads no Tailwind script. Every class of the example above is in that stylesheet, and none of its classes goes away in 1.x. The list is [`tests/tailwind-classes.txt`](https://github.com/zephyrus-framework/leaf/blob/v1.0.0/tests/tailwind-classes.txt) in the theme's repository.

A class the stylesheet lacks (`py-24`, `text-4xl` or `mt-4`, for instance) has no style. On the binary CLI, which ships the theme's stylesheet as it is:

- write its rule in a stylesheet of your own under `public/`, linked from your copy of `templates/partials/head.latte` after the theme's stylesheets;
- or load Tailwind in the browser from that same copy of `head.latte`, with the snippet of the theme's [Styling](https://github.com/zephyrus-framework/leaf/blob/v1.0.0/README.md#styling) section. Under a Content Security Policy, that script needs `https://cdn.tailwindcss.com` in `script-src`.

On the Composer tier (a project created from the 1.0 template, or one that took over its compiled stylesheet), `composer build` compiles the stylesheet again from your templates and Markdown pages before it builds the pages, so your classes are in it.

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
