---
title: Versioning and stability
order: 6
description: What Leaf 1.x keeps working until 2.0, what it does not cover, and how to move a site from 0.1.x.
---

# Versioning and stability

Leaf follows [semantic versioning](https://semver.org/) from 1.0.0: nothing public breaks before 2.0.

## One number, three repositories

Leaf is released as three repositories under the same version number:

- [`zephyrus-framework/leaf-core`](https://github.com/zephyrus-framework/leaf-core): the PHP library, on Packagist
- [`zephyrus-framework/leaf`](https://github.com/zephyrus-framework/leaf): the theme and the Composer project template (`composer create-project`)
- [`zephyrus-framework/leaf-cli`](https://github.com/zephyrus-framework/leaf-cli): the `leaf` binary, which embeds the theme and leaf-core

## Releases

- **Patch** (1.0.1): fixes.
- **Minor** (1.1.0): additions that keep everything public working.
- **Major** (2.0.0): the only kind of release that may break something public.
- **Deprecation**: something public is deprecated first, with a "Deprecated" line in the changelog, and removed at the next major release.

## Public in 1.x

1. **Configuration**: every `config.yml` key Leaf reads (the `leaf` and `localization` sections), its default and its meaning. No key is renamed or removed; a new key comes with a default that keeps the output as it was.
2. **Content**: `content/<section>/<slug>.md` and `content/<locale>/...`, the front matter keys Leaf reads, the order and the titles taken from file names, `locale/` and its strings.
3. **Output**: the layout of `dist/` (page paths, the locale prefix, a `404.html` per locale, `sitemap.xml`, `robots.txt`, a `search.json` per locale) and the fields of a `search.json` entry (`title`, `section`, `url`, `excerpt`, `headings`, `content`). Fields can be added, never removed or given another meaning.
4. **Templates**: the names of the templates Leaf renders (`layouts/docs.latte`, `layouts/landing.latte`, `landing.latte`, `docs/page.latte`, `404.latte`, and `head`, `nav`, `footer`, `sidebar`, `toc` and `search-modal` under `partials/`), the variables each one receives, the globals injected in every template (`$leafName`, `$leafBaseUrl`, `$localePrefix`...) and Leaf's Latte functions and filters (`localize`...). No variable is removed or changes type.
   - **Not public**: the markup and the CSS classes inside the theme's templates, `app.css` (except the properties of point 5) and the theme's JavaScript. A template you override belongs to your site: for each release, the theme's [changelog](https://github.com/zephyrus-framework/leaf/blob/main/CHANGELOG.md) names every template, stylesheet or script that changed and what an override must take over.
5. **Styling**: the theme ships its Tailwind CSS classes compiled with Tailwind CSS 3.4.17, in `assets/css/tailwind.css`, and loads no Tailwind script.
   - No class of that stylesheet goes away in 1.x. The theme's CI checks it against the reference list, [`tests/tailwind-classes.txt`](https://github.com/zephyrus-framework/leaf/blob/v1.0.0/tests/tailwind-classes.txt).
   - Its colour tokens (`deep`, `surface`, `elevated`, `border`, `border-accent`, `body`, `bright`, `muted`, `accent`, `accent-light`, `accent-fill`, `accent-fill-hover`, `accent-glow`) and fonts (`font-body`, `font-mono`) stay.
   - The theme stays on Tailwind CSS 3 for all of 1.x: version 4 changes what classes such as `shadow-sm`, `rounded` or `ring` mean, which only a major release may do.
   - The CSS custom properties of the theme's [Theme](https://github.com/zephyrus-framework/leaf/blob/v1.0.0/README.md#theme) section (`--bg-deep`, `--accent`, `--text`...) are neither renamed nor removed, and neither are the three selectors under which `app.css` sets them: `:root`, `[data-theme="light"]`, and `:root:not([data-theme="dark"])` inside `@media (prefers-color-scheme: light)`. Set yours under the same three. The rest of `app.css` is not public.
   - For a class the stylesheet lacks, the Composer tier compiles the stylesheet again from your templates and Markdown pages (`composer build`), and a binary project loads Tailwind from its `templates/partials/head.latte` or brings its own CSS: see [Styling a page](/content-system/custom-pages/#styling-a-page).
6. **Hooks**: the `post_build` entries, how they run (without a shell, as a list of arguments), their environment variables and what a failing hook does.
7. **CLI**: the `init`, `dev`, `build` and `eject` commands and their options, the shape of a binary project, the `LEAF_VERSION` and `LEAF_PREFIX` variables of `install.sh`, and the names of the assets of a release (`leaf-<os>-<arch>`, `checksums.txt`), which workflows download by name.
8. **PHP API** (Composer tier): the public and protected methods of `Leaf\Kernel`, `BuildCommand`, `PageDiscovery`, `DevRouter`, `StaticSiteBuilder`, `StaticBuildResult`, `Config\LeafConfig`, `Content\ContentLoader`, `Content\SearchIndexBuilder`, `Content\MarkdownParser`, `Content\ParsedMarkdown`, `Seo\SitemapGenerator`, `Seo\RobotsGenerator` and `Localization\TranslationLatteExtension`.
   - **Internal**, marked `@internal` and free to change in any release: `FileWatcher`, `LeafLatteExtension` (the globals it injects are public under point 4, the class is not), `Localization\LocaleCode` and `Content\SlugTitle`.
9. **Platforms**: PHP `^8.4` and `zephyrus-framework/core` `^3.17` on the Composer tier. The PHP floor can rise in a minor release, announced in the changelog, never in a patch; Composer then keeps a site on the last 1.x release its PHP can run. The binary runs the `php` on your `PATH`; the versions of the PHP libraries it embeds are not public.

## Not covered

- The exact HTML that Markdown produces: an update of CommonMark can change a detail.
- The order of the entries of `search.json`.
- Everything listed as not public or internal above.

## Security fixes

A security fix can tighten a refusal or change an output in a minor or patch release, when that behaviour was itself the flaw. The changelog names it.

## Upgrading from 0.1.x

- **Composer tier**: require `"zephyrus-framework/leaf-core": "^1.0"` (Composer does not move a `^0.1` constraint to 1.0 by itself). A project created with `composer create-project` or `leaf eject` before 1.0 requires `"@dev"`: change it to `"^1.0"`, remove `"minimum-stability": "dev"`, then run `composer update zephyrus-framework/leaf-core`.
- **Binary tier**: set `LEAF_VERSION` to `v1.0.0` and, with it, the expected SHA-256: the `leaf-linux-amd64` line of the release's `checksums.txt`.
- **Front matter** is now always read as YAML 1.2: `yes`, `no`, `on` and `off` are strings. Write `true` or `false`.
- **A locale listed twice** in `localization.supported_locales`, in any case (`en` and `EN`), stops the build: remove the duplicate.
- **Tailwind**: a template or a Markdown page of your site that uses a class the theme's stylesheet lacks loses its style. See [Styling a page](/content-system/custom-pages/#styling-a-page).
- **Theme overrides**: take over the changes the theme's [changelog](https://github.com/zephyrus-framework/leaf/blob/v1.0.0/CHANGELOG.md) lists for each file you override.

The full guide, for both tiers, is [UPGRADE.md](https://github.com/zephyrus-framework/leaf-core/blob/v1.0.0/UPGRADE.md). Each release is described in the changelogs of [leaf-core](https://github.com/zephyrus-framework/leaf-core/blob/main/CHANGELOG.md) and of the [theme](https://github.com/zephyrus-framework/leaf/blob/main/CHANGELOG.md).
