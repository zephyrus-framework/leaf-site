---
title: Search
order: 3
---

# Search

Leaf includes a full-text search system that works entirely client-side. No server or external service required.

## How it works

1. During the build, `SearchIndexBuilder` scans all Markdown files and generates a `search.json` file
2. The search modal loads this JSON on first open
3. Searches run locally in the browser with fuzzy matching

## Using search

- Click the **Search** button in the nav bar
- Or press **Ctrl+K** (Cmd+K on Mac)
- Type your query and results appear instantly
- Navigate results with arrow keys, press Enter to go

## Search index

The generated `search.json` contains an entry for each page:

```json
[
  {
    "title": "Installation",
    "section": "getting-started",
    "url": "/getting-started/installation",
    "excerpt": "First 300 characters of the page content...",
    "headings": ["Requirements", "Create a new project", "Dev server"]
  }
]
```

## Scoring

Results are ranked by relevance:

| Match type | Score |
|-----------|-------|
| Exact title match | 100 |
| Title substring | 50 |
| Heading match | 20 |
| Excerpt match | 10 |
| Section match | 5 |

The top 10 results are displayed.

## Keyboard shortcuts

| Key | Action |
|-----|--------|
| Ctrl+K / Cmd+K | Open/close search |
| Arrow keys | Navigate results |
| Enter | Go to selected result |
| Escape | Close search |
