---
title: Pages
order: 1
---

# Pages

Documentation pages are Markdown files with YAML front matter. They live in the `content/` directory, organized into sections.

## File structure

```
content/
  getting-started/
    introduction.md       # /getting-started/introduction
    installation.md       # /getting-started/installation
  guides/
    deployment.md         # /guides/deployment
    customization.md      # /guides/customization
```

Each directory under `content/` is a **section**. Each `.md` file is a **page**. The URL is derived from the directory and filename: `/{section}/{slug}`.

## Front matter

Every page needs YAML front matter with at least `title` and `order`:

```yaml
---
title: Installation
order: 2
description: How to install and set up Leaf
---

# Installation

Your content here...
```

| Field | Required | Description |
|-------|----------|-------------|
| `title` | Yes | Page title, shown in sidebar and browser tab |
| `order` | Yes | Sort order within its section (lower = earlier) |
| `description` | No | Meta description for SEO, also used in search excerpts |

## Markdown features

Leaf uses [CommonMark](https://commonmark.org/) with GitHub Flavored Markdown extensions:

### Basic formatting

```markdown
**Bold text** and *italic text*

> Blockquotes render with a purple accent border

- Unordered lists
- With nested items
  - Like this

1. Ordered lists
2. Work too
```

### Code blocks

Fenced code blocks with syntax highlighting (powered by Prism.js):

````markdown
```php
$builder = new StaticSiteBuilder($app, $router);
$result = $builder->build();
```
````

Supported languages: PHP, YAML, Bash, JSON, SQL, HTML, JavaScript, CSS, and more.

Each code block gets an automatic **copy button** on hover.

### Tables

```markdown
| Column A | Column B | Column C |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
```

### Heading permalinks

Headings (h2, h3, h4) automatically get permalink anchors, visible on hover. This makes it easy to link to specific sections.

### Images

```markdown
![Alt text](/assets/images/screenshot.png)
```

Images are rendered with rounded corners and a subtle border.

## Inline code

Use backticks for inline code: `` `leaf build` `` renders as `leaf build` with a subtle background and accent color.
