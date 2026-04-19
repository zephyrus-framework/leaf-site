---
title: CLI Reference
order: 4
---

# CLI Reference

The `leaf` binary has five subcommands. All work the same on macOS, Linux, and Windows.

## `leaf init <name>`

Scaffolds a new site in the `<name>` directory.

```bash
leaf init my-docs
```

Creates:

```
my-docs/
  content/
    getting-started/introduction.md
  public/
    assets/css/
    assets/js/
    assets/images/
  config.yml
```

No `app/`, `bin/`, `vendor/`, or `composer.json`. The framework lives inside the binary.

### Flags

| Flag | Default | Effect |
|------|---------|--------|
| `--force` | off | Scaffold into a non-empty directory, overwriting matching files |

Refuses to run into a non-empty directory without `--force` so you don't accidentally overwrite a real project.

## `leaf dev`

Starts a local server with live reload.

```bash
leaf dev           # listens on :8080
leaf dev --addr :3000
leaf dev --dir ./some/path
```

Builds once at startup, serves `dist/`, watches `content/`, `templates/`, `public/`, and `config.yml`. When anything changes:

1. Full rebuild into `dist/` (debounced ~250ms)
2. SSE event pushed to every open browser tab
3. Page reloads

Reload uses Server-Sent Events, not WebSocket — zero proxy friction, works behind nginx, Caddy, or a tunnel.

### Flags

| Flag | Default | Effect |
|------|---------|--------|
| `--addr` | `:8080` | Host:port to bind |
| `--dir` | `.` | Project root |

## `leaf build`

Renders every page to static HTML in `dist/`.

```bash
leaf build
leaf build --dir ./some/path
leaf build --keep-tmp
```

Internally: merges the bundled framework + your project into a tempdir, invokes PHP to run the build pipeline, copies the resulting `dist/` back into your project root.

### Flags

| Flag | Default | Effect |
|------|---------|--------|
| `--dir` | `.` | Project root |
| `--keep-tmp` | off | Don't delete the merged build tempdir (useful for debugging) |

## `leaf eject`

Converts a CLI-tier project into a full Composer project.

```bash
leaf eject
composer install
composer build
```

Writes the framework files (`app/`, `bin/`, `composer.json`, etc.) into your project alongside the existing `content/`, `templates/`, `public/`, `config.yml`. Your user content is not touched.

One-way. Refuses to run if `composer.json` already exists unless you pass `--force`.

### Flags

| Flag | Default | Effect |
|------|---------|--------|
| `--dir` | `.` | Project root |
| `--force` | off | Overwrite existing framework files |

## `leaf version`

Prints the version string.

```bash
$ leaf version
leaf v0.1.0-dev
```

## `leaf help`

Prints the subcommand list.

```bash
$ leaf help
leaf - a zero-dependency static site CLI

Usage:
    leaf <command> [flags]

Commands:
    init <name>    Scaffold a new site
    dev            Serve with live reload
    build          Generate static HTML into dist/
    eject          Convert to the full Composer project path
    version        Print version
    help           Show this help
```

## Exit codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Runtime error (missing config, build failure, etc.) |
| `2` | Bad flags / usage |
| Other | PHP process exit code passed through (build failures) |

## Environment

The binary reads these variables:

| Var | Used by | Purpose |
|-----|---------|---------|
| `LEAF_DEFAULTS_DIR` | `build`, `init`, `eject` | Override the bundled framework source (developer use) |
| `PATH` | `build`, `dev` | Must include `php` for the current build (until FrankenPHP is wired in) |
