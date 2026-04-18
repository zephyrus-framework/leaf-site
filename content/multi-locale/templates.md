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

A typical language switcher in the nav:

```latte
{var $dl = $defaultLocale ?? 'en'}

{foreach $supportedLocales as $loc}
    {if $loc === $currentLocale}
        <span class="current">{$loc|upper}</span>
    {else}
        <a href="{$loc === $dl ? '/' : '/' . $loc . '/'}"
           class="lang-switch"
           data-locale="{$loc}"
           data-default="{$dl}">
            {$loc|upper}
        </a>
    {/if}
{/foreach}
```

## Path preservation on language switch

When switching languages, you typically want to stay on the same page. Add this JavaScript:

```javascript
var langSwitches = document.querySelectorAll('.lang-switch[data-locale]');
if (langSwitches.length) {
    var path = window.location.pathname;
    var defaultLang = langSwitches[0].getAttribute('data-default') || 'en';
    var stripped = path.replace(/^\/(en|fr|ar)(\/|$)/, '/');
    langSwitches.forEach(function (link) {
        var loc = link.getAttribute('data-locale');
        if (loc === defaultLang) {
            link.href = stripped === '/' ? '/' : stripped;
        } else {
            link.href = '/' + loc + (stripped === '/' ? '/' : stripped);
        }
    });
}
```

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
