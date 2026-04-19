---
title: Templates & Links
order: 2
---

# Locale-Aware Templates

When building a multi-locale site, templates need to handle locale-aware URLs and language switching.

## Locale-aware links

The default locale has no URL prefix. Other locales use `/{locale}/`:

```latte
{var $dl = $defaultLocale ?? 'en'}
{var $localePrefix = ($currentLocale ?? $dl) === $dl ? '' : '/' . $currentLocale}

<a href="{$localePrefix}/">Home</a>
<a href="{$localePrefix}/blog">Blog</a>
<a href="{$localePrefix}/about">About</a>
```

For the default locale (English), links become `/`, `/blog`, `/about`.
For French, they become `/fr/`, `/fr/blog`, `/fr/about`.

## Language switcher

The bundled nav renders a language switcher **automatically** when `supported_locales` has more than one entry. It sits next to the theme toggle, uses a dropdown with each locale's code, and its hrefs are rewritten client-side so clicking a locale preserves the current path.

Nothing required from you in the default case: drop `fr` (or any second locale) into your `supported_locales` and the switcher appears.

### If you're rendering your own nav

If your `templates/partials/nav.latte` is a full custom override and you removed the bundled switcher block, render it back yourself:

```latte
{if count($supportedLocales ?? []) > 1}
<div class="lang-switcher" data-current="{$currentLocale}" data-default="{$defaultLocale}">
    <button type="button" class="lang-switcher-button" onclick="toggleLangSwitcher(this)">
        {$currentLocale|upper}
    </button>
    <ul class="lang-switcher-menu" hidden>
        {foreach $supportedLocales as $loc}
        <li>
            <a class="lang-switcher-option{if $loc === $currentLocale} is-active{/if}"
               data-locale="{$loc}"
               href="{$loc === $defaultLocale ? '/' : '/' . $loc . '/'}">{$loc|upper}</a>
        </li>
        {/foreach}
    </ul>
</div>
{/if}
```

The client-side helper at `/assets/js/lang-switcher.js` handles dropdown open/close, outside-click dismissal, and path preservation. It runs automatically as long as the script tag is included (the bundled layouts include it).

## Canonical and hreflang tags

For SEO, each page should declare its canonical URL and alternate language versions. Pass `requestPath` from your controller:

```php
return $this->render('page', [
    'requestPath' => '/blog/' . $slug,
]);
```

Then in your head partial:

```latte
{var $canonicalBase = $leafProductionUrl ?: 'https://example.com'}
{var $dl = $defaultLocale ?? 'en'}
{var $pageSuffix = $pagePath === '/' ? '/' : rtrim($pagePath, '/') . '/'}
{var $curLocale = $currentLocale ?? $dl}

<link rel="canonical" href="{$canonicalBase}{$curLocale === $dl ? '' : '/' . $curLocale}{$pageSuffix}">
{foreach $supportedLocales as $loc}
<link rel="alternate" hreflang="{$loc}" href="{$canonicalBase}{$loc === $dl ? '' : '/' . $loc}{$pageSuffix}">
{/foreach}
<link rel="alternate" hreflang="x-default" href="{$canonicalBase}{$pageSuffix}">
```

This generates proper hreflang tags that search engines use to serve the right language version.
