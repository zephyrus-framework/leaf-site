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
{layout 'layouts/landing.latte'}

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
- `About.latte` → rejected (uppercase disallowed)
- `partial.latte` inside a subdirectory (`pages/marketing/partial.latte`) → ignored (only top-level files are exposed as routes)

Rename to fit the rules, and the route snaps into place.

## Layouts and partials

Pages extend layouts exactly like any other view:

```latte
{layout 'layouts/landing.latte'}

{block content}
<section>…</section>
{/block}
```

Need a nav, footer, or hero partial? Use `{include 'partials/nav.latte'}` the same way docs pages do. Or author your own partial under `templates/partials/<name>.latte` and reference it.

## Binary CLI vs Composer

Both tiers work the same. On the Binary CLI tier, the `leaf` binary merges your `templates/pages/` into the bundled `app/Views/pages/` at build time; no further wiring. On the Composer tier, you can either use `templates/pages/` (same pattern, mapped at build) or drop files directly into `app/Views/pages/`.

If you ejected to the Composer tier and want full control over `PagesController`, it's a standard Zephyrus controller in `app/Controllers/PagesController.php`: inject services, swap the view resolution, add caching, whatever you need.

## Using PHP or HTML instead of Latte

The override surface accepts any of the three formats:

- `templates/pages/about.latte`: full Latte power, recommended.
- `templates/pages/about.php`: plain PHP view, echo markup directly.
- `templates/pages/about.html`: copied through as static HTML, no variable interpolation.

HTML is the escape hatch for "I pasted markup from Tailwind UI and don't want any framework involved." The `leaf build` pipeline still copies it to `dist/about/index.html` and the URL works.

## When to eject

Custom pages cover the 90% case: static marketing pages, a contact form that posts to a third party, a pricing page with Stripe checkout button, legal text. If you need something the template doesn't (form submission handlers, API endpoints, custom middleware, database queries on the dynamic side), that's when `leaf eject` kicks in and you get the full Zephyrus toolkit.
