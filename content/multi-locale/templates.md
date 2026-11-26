---
title: Templates & Links
order: 2
---

# Locale-Aware Templates

When building a multi-locale site, templates need to handle locale-aware URLs and language switching.

## Locale-aware links

The default locale has no URL prefix. Other locales use `/{locale}/`. Every template receives that prefix as `$localePrefix`: `''` for the default locale (and on a single-locale site), `'/fr'` for French.

```latte
<a href="{$leafBaseUrl}{$localePrefix}/">Home</a>
<a href="{$leafBaseUrl}{$localePrefix}/blog/">Blog</a>
<a href="{$leafBaseUrl}{$localePrefix}/about/">About</a>
```

For the default locale (English), links become `/`, `/blog/`, `/about/`.
For French, they become `/fr/`, `/fr/blog/`, `/fr/about/`. With `base_url: "/docs"`, `/docs/fr/blog/`.

The sidebar and previous/next items carry a `url` that already includes the base URL but no locale prefix. To link one in an overridden partial, build the link from its parts, as the bundled partials do:

```latte
<a href="{$leafBaseUrl}{$localePrefix}/{$item['section']}/{$item['slug']}/">{$item['title']}</a>
```

## Language switcher

The bundled nav renders a language switcher **automatically** when `supported_locales` has more than one entry. It sits next to the theme toggle: a globe button with the current locale code opens a menu of locale codes. Its links are rewritten in the browser so that switching keeps the current page and the base URL (`/docs/guides/auth/` to `/docs/fr/guides/auth/`); on the 404 page they lead to each locale's home page instead. Tab reaches the button, Enter opens the menu, Escape closes it and returns focus to the button.

Nothing required from you in the default case: drop `fr` (or any second locale) into your `supported_locales` and the switcher appears.

### If you're rendering your own nav

If your `templates/partials/nav.latte` is a full custom override and you removed the bundled switcher block, render it back yourself:

```latte
{if count($supportedLocales) > 1}
<div class="lang-switcher" data-current="{$currentLocale}" data-default="{$defaultLocale}"
     data-base-url="{$leafBaseUrl}" data-locale-homes="{($notFound ?? false) ? 'true' : 'false'}">
    <button type="button" class="lang-switcher-button" aria-expanded="false"
            aria-controls="lang-switcher-menu" onclick="toggleLangSwitcher(this)">
        {$currentLocale|upper}
    </button>
    <ul id="lang-switcher-menu" class="lang-switcher-menu" hidden>
        {foreach $supportedLocales as $loc}
        <li>
            <a class="lang-switcher-option{if $loc === $currentLocale} is-active{/if}"
               n:attr="aria-current: $loc === $currentLocale ? 'true' : null"
               data-locale="{$loc}" hreflang="{$loc}" lang="{$loc}"
               href="{$leafBaseUrl}{$loc === $defaultLocale ? '' : '/' . $loc}/">{$loc|upper}</a>
        </li>
        {/foreach}
    </ul>
</div>
{/if}
```

The helper at `/assets/js/lang-switcher.js` opens and closes the menu (outside click, focus leaving it, Escape) and rewrites each link to the current page. It reads `data-default` and `data-base-url`; `data-locale-homes="true"` keeps the links on each locale's home, which the bundled 404 template asks for by setting `$notFound`. The bundled layouts load the script; an overridden layout must keep its `<script>` tag.

## Canonical and hreflang tags

For SEO, each page should declare its canonical URL and alternate language versions. The bundled head writes neither: add them in an overridden `templates/partials/head.latte`.

On the Binary CLI nothing sets `$requestPath`, so build the page path from what the bundled controllers pass: `$section` and `$slug` on Markdown pages, `$pagePath` on custom pages. A Composer-tier controller can pass `requestPath` itself, which the snippet prefers:

```latte
{var $dl = $defaultLocale ?? 'en'}
{var $path = rtrim($requestPath ?? (isset($section, $slug) ? '/' . $section . '/' . $slug : ($pagePath ?? '')), '/')}
{if $leafProductionUrl !== '' && !($notFound ?? false)}
<link rel="canonical" href="{$leafProductionUrl}{$localePrefix}{$path}/">
{foreach $supportedLocales as $loc}
<link rel="alternate" hreflang="{$loc}" href="{$leafProductionUrl}{$loc === $dl ? '' : '/' . $loc}{$path}/">
{/foreach}
<link rel="alternate" hreflang="x-default" href="{$leafProductionUrl}{$path}/">
{/if}
```

On the French guide page it yields `https://example.com/fr/guide/intro/` as canonical, and `https://example.com/` on the landing. The 404 page (`$notFound` is set by the bundled 404 template) gets no canonical. A page that exists only under `content/fr/` still lists alternates for every locale: guard them if that matters to you.
