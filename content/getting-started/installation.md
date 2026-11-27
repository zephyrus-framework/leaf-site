---
title: Installation
order: 2
---

# Installation

Two ways to install Leaf. Pick one.

## Binary CLI (recommended)

One command on macOS or Linux:

```bash
curl -fsSL https://leaf.ophelios.com/install.sh | sh
```

The script detects your OS/arch, downloads the matching binary from the [GitHub release](https://github.com/zephyrus-framework/leaf-cli/releases/latest), verifies the checksum, and installs to `/usr/local/bin/leaf`.

Then scaffold and build:

```bash
leaf init my-docs
cd my-docs
leaf dev      # live reload on http://localhost:8080
leaf build    # writes dist/
```

### Manual download

Grab the binary for your platform from the [releases page](https://github.com/zephyrus-framework/leaf-cli/releases/latest):

| Platform | Binary |
|----------|--------|
| macOS (Apple Silicon) | `leaf-darwin-arm64` |
| macOS (Intel) | `leaf-darwin-amd64` |
| Linux (x86_64) | `leaf-linux-amd64` |
| Linux (arm64) | `leaf-linux-arm64` |
| Windows | `leaf-windows-amd64.exe` |

Verify the checksum, then `chmod +x leaf-<platform>` and move it into your `PATH`. On macOS, if you downloaded via a browser, run `xattr -d com.apple.quarantine leaf-<platform>` to clear the Gatekeeper flag.

### Install options

Environment variables the install script respects:

| Var | Default | What it does |
|-----|---------|--------------|
| `LEAF_PREFIX` | `/usr/local/bin` | Where to install the binary |
| `LEAF_VERSION` | `latest` | Specific release tag (e.g. `v1.0.0`) |

### Runtime requirement

Installing needs no PHP, but building does: the binary shells out to the `php` on your `PATH`, which must be **PHP 8.4+** with the `intl`, `mbstring` and `tokenizer` extensions. Without `intl` the build stops; without `tokenizer` every page fails with HTTP 500. Most PHP packages ship `tokenizer`. Removing the PHP dependency (via FrankenPHP static link) is on the roadmap.

## Composer template

For PHP developers who want controllers, Composer packages, and full build-script control. The template and `zephyrus-framework/leaf-core` are tagged releases, so this installs stable versions:

```bash
composer create-project zephyrus-framework/leaf my-docs
cd my-docs
composer dev     # dev server with live reload
composer build   # compiles the Tailwind stylesheet, then writes dist/
```

### Requirements

- **PHP 8.4+** with `intl`, `mbstring`, `pdo`, `fileinfo`, `sodium` and `tokenizer` (required by `zephyrus-framework/core` and Latte; Composer checks them on install)
- **Composer 2.x**
- To compile the Tailwind stylesheet (`composer build`, `composer css`): `sh`, `curl` or `wget`, `sha256sum` or `shasum`, and access to GitHub on the first run, which downloads the standalone Tailwind CSS CLI (no Node.js) into `~/.cache/leaf`

### Adding Leaf to an existing Zephyrus project

```bash
composer require zephyrus-framework/leaf-core
```

It resolves to the latest tagged release, with no change to your `minimum-stability`.

Then extend `Leaf\Kernel` in your Application class and use `Leaf\BuildCommand` in your build script. See the [BuildCommand](/building-sites/build-command/) reference.

## Switching paths: `leaf eject`

Started with the CLI but need PHP extensibility?

```bash
leaf eject
composer install
```

This writes the full framework (`app/`, `bin/`, `composer.json`, `vendor/` after install) into your project directory while keeping `content/`, `templates/`, `public/`, `locale/` and `config.yml` intact. Your translations survive: the theme only adds the keys your `locale/` files lack. Overrides under `templates/` are not read by `composer build`: move them into `app/Views/`. One-way: you now manage a Composer project.
