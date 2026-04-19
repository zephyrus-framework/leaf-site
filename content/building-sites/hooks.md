---
title: Post-build Hooks
order: 3
description: Run arbitrary scripts after leaf build, without ejecting to the Composer tier.
---

# Post-build Hooks

Sometimes `leaf build` needs to be followed by a step that doesn't belong inside the PHP pipeline: regenerate an OG social card, compress images, upload `dist/` to a CDN, write a deploy manifest. Config-declared hooks let you do this without ejecting.

## Declare hooks in `config.yml`

```yaml
leaf:
  post_build:
    - "./scripts/generate-og-image.sh"
    - ["./scripts/optimize-images.sh", "--jpeg-quality=85"]
    - "./scripts/deploy.sh"
```

Each entry is either:

- A **string** — path to an executable with no args.
- An **array of strings** — first element is the executable, the rest are argv.

## How it runs

Hooks execute **after** `leaf build` succeeds and `dist/` has been published into your project root. At that point:

- `cwd` is your real project root (not a build tempdir), so hooks can read or write anything in the project.
- `dist/` contains the freshly built HTML, CSS, JS, `sitemap.xml`, etc.
- Hook stdout and stderr stream live to your terminal.
- Hooks run **sequentially, in YAML order**. A non-zero exit aborts the chain and fails the overall `leaf build`.
- No shell interpretation: `"./scripts/x.sh && ./y.sh"` won't do what you expect. Write a wrapper script if you need shell logic.

## What hooks are good for

- Regenerating derived assets (OG cards, favicons, image variants)
- Running a linter, link-checker, or accessibility audit against `dist/`
- Uploading `dist/` to S3, Cloudflare R2, or another CDN
- Writing a deploy manifest or invalidating a cache
- Sending a Slack ping when the build finishes

## What hooks are *not* good for

- **Modifying content that the build renders.** That happens before the hook. Put that logic in your Markdown or templates instead.
- **Replacing the build itself.** If you need fundamentally different behaviour, eject to the Composer tier.
- **Long-running daemons.** Hooks are expected to exit.

## Example: the OG image generator

`leaf.ophelios.com` regenerates its social card on every build:

```yaml
leaf:
  post_build:
    - "./scripts/generate-og-image.sh"
```

`scripts/generate-og-image.sh` launches headless Chrome against an HTML template and writes `public/assets/images/og-image.png`. Since it runs post-build, the generated file is not yet copied into `dist/` — the next build picks it up. For regeneration-on-every-build that lands in `dist/` immediately, point the script's output at `dist/` directly.

## Integration with `leaf dev`

`leaf dev` runs the same pipeline on every file change. Hooks fire after each successful rebuild. If that's too aggressive (for a slow OG regenerator, say), gate it with a check inside the hook script:

```bash
#!/usr/bin/env bash
# Only regenerate OG if the template source has changed.
if [ resources/og-templates/site.html -nt public/assets/images/og-image.png ]; then
    ./scripts/render-og.sh
fi
```

## Composer tier

On the Composer tier, the same `post_build` config is read by `BuildCommand` and hooks run identically. You *also* still have `$command->onPostBuild(fn (...)) => ...)` available in `bin/build.php` for PHP-level callbacks that need access to the `StaticBuildResult` object (pages built, errors, build duration).

Use the right tool:

- **`post_build` in config** for language-agnostic shell scripts.
- **`onPostBuild` in `bin/build.php`** for PHP callbacks that need the build result or the framework.

## Exit codes

A failing hook propagates to `leaf build`. Exit 0 = build succeeded; anything non-zero = build failed and subsequent hooks are skipped.
