---
title: Reference
order: 1
---

# Configuration Reference

All configuration lives in `config.yml` at the project root.

## Full example

```yaml
application:
  environment: !env APP_ENV, dev
  debug: !env APP_DEBUG, true

localization:
  locale: "en"
  supported_locales:
    - "en"
    - "fr"
  locale_path: "locale"
  timezone: "America/Montreal"

render:
  engine: "latte"
  directory: "app/Views"
  cache: "cache/latte"
  mode: "always"

leaf:
  name: "My Documentation"
  version: "2.1.0"
  description: "Technical documentation for My Project."
  github_url: "https://github.com/user/repo"
  content_path: "content"
  output_path: "dist"
  base_url: ""
  production_url: "https://docs.example.com"
  author: "Your Name"
  author_url: "https://example.com"
  license: "MIT"
  sections:
    getting-started: "Getting Started"
    guides: "Guides"
    api: "API Reference"
```

## Leaf section fields

| Field | Default | Description |
|-------|---------|-------------|
| `name` | `"My Project"` | Site name, shown in the nav bar and page titles |
| `version` | `"0.1.0"` | Version badge displayed in the nav |
| `description` | `""` | Meta description for SEO |
| `github_url` | `""` | GitHub link in the nav (hidden if empty) |
| `content_path` | `"content"` | Directory containing Markdown files |
| `output_path` | `"dist"` | Static build output directory |
| `base_url` | `""` | URL prefix for internal links (e.g., `"/docs"`) |
| `production_url` | `""` | Production URL for sitemap/robots generation |
| `author` | `""` | Author name in the sidebar footer |
| `author_url` | `""` | Author link |
| `license` | `"MIT"` | License badge in the sidebar footer |
| `sections` | `{}` | Ordered map of section slug to display name |

## Environment variables

Use the `!env` YAML tag to reference environment variables:

```yaml
application:
  environment: !env APP_ENV, dev     # Uses $APP_ENV, defaults to "dev"
  debug: !env APP_DEBUG, true        # Uses $APP_DEBUG, defaults to true
```

Environment variables are loaded from a `.env` file at the project root via Dotenv.

## Localization section

| Field | Default | Description |
|-------|---------|-------------|
| `locale` | `"en"` | Default locale code |
| `supported_locales` | `["en"]` | List of all supported locales |
| `locale_path` | `""` | Path to JSON translation files |
| `timezone` | `"UTC"` | Application timezone |

## Render section

| Field | Default | Description |
|-------|---------|-------------|
| `engine` | `"latte"` | Template engine (`"latte"` or `"php"`) |
| `directory` | `"app/Views"` | Template directory |
| `cache` | `"cache/latte"` | Template cache directory |
| `mode` | `"always"` | Cache mode (`"always"` or `"never"`) |

## Template globals

The `LeafLatteExtension` injects these variables into every template:

| Variable | Source |
|----------|--------|
| `$leafName` | `leaf.name` |
| `$leafVersion` | `leaf.version` |
| `$leafDescription` | `leaf.description` |
| `$leafGithubUrl` | `leaf.github_url` |
| `$leafAuthor` | `leaf.author` |
| `$leafAuthorUrl` | `leaf.author_url` |
| `$leafLicense` | `leaf.license` |
| `$leafBaseUrl` | `leaf.base_url` |
| `$leafProductionUrl` | `leaf.production_url` |
