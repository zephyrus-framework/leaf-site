---
title: Sections
order: 2
---

# Sections

Sections are directories under `content/` that group related pages. They appear as groups in the sidebar navigation.

## Defining sections

Register sections in `config.yml` to control their order and display names:

```yaml
leaf:
  sections:
    getting-started: "Getting Started"
    guides: "Guides"
    api-reference: "API Reference"
```

The YAML key is the directory name under `content/`. The value is the label shown in the sidebar.

## Section order

The order in `config.yml` determines the sidebar order. If sections are not listed in the config, they are discovered automatically from the `content/` directory and sorted alphabetically.

## Page order within sections

Pages within a section are sorted by the `order` field in their front matter:

```yaml
---
title: Introduction
order: 1
---
```

Pages with the same `order` value are sorted alphabetically by filename.

## Navigation

The sidebar is automatically generated from your sections and pages. The `ContentLoader` provides:

- **Sidebar structure** -- sections with their ordered pages
- **Previous/next links** -- pagination at the bottom of each page, crossing section boundaries
- **First page URL** -- used for the root redirect

## Adding a new section

1. Create a directory under `content/`:
   ```
   content/advanced/
   ```

2. Add it to `config.yml`:
   ```yaml
   leaf:
     sections:
       getting-started: "Getting Started"
       advanced: "Advanced"
   ```

3. Create pages inside:
   ```
   content/advanced/custom-themes.md
   ```

4. The new section appears in the sidebar on the next page load (dev server) or build.
