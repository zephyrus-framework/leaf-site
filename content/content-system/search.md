---
title: Search
order: 3
---

# Search

Leaf includes a full-text search system that works entirely client-side. No server or external service required.

## How it works

1. During the build, `SearchIndexBuilder` reads every page and writes `search.json` (on a multi-locale site, one per locale, such as `/fr/search.json`)
2. The search dialog loads it the first time it opens
3. Queries run in the browser, against the titles, the headings and the full text of the pages

## Using search

- Click the **Search** button in the nav bar, or press **Ctrl+K** (**Cmd+K** on Mac)
- Type two characters or more: results appear as you type
- The first result is preselected, so Enter opens it. The up and down arrows move the selection, and so does the pointer
- A page found only in its body text opens at the first matching word, through a text fragment (`#:~:text=static`) that browsers supporting it scroll to and highlight

While the index loads, the dialog says **Loading search...** and runs the query as soon as the index arrives. An index that cannot be loaded, or has not arrived after 10 seconds, makes the dialog say **Search is unavailable. Close it and try again.**, and it is fetched again the next time the dialog opens.

## Search index

The generated `search.json` contains an entry for each page:

```json
[
  {
    "title": "Installation",
    "section": "getting-started",
    "url": "/getting-started/installation",
    "excerpt": "First 300 characters of the page text...",
    "headings": ["Requirements", "Create a new project", "Dev server"],
    "content": "The full text of the page..."
  }
]
```

## Ranking

Each word of the query is a term. Pages that contain more of the terms come first; among pages that contain as many, the higher score comes first. Each term scores:

| Where | Points |
|-------|--------|
| Title | 100 if the title is the term, otherwise 50 if it contains it |
| Each heading | 20 × occurrences, up to 1 per heading |
| Excerpt or page text, whichever scores higher | 10 × occurrences in the excerpt, up to 1, or 3 × occurrences in the page text, up to 10 |
| Section | 5 × occurrences, up to 1 |

An occurrence counts 1 for a whole word, 0.5 at the start of a word (`build` in `builder`) and 0.25 inside a word (`build` in `rebuild`), so whole words rank above parts of words.

The top 10 results are displayed.

## Keyboard shortcuts

| Key | Action |
|-----|--------|
| Ctrl+K / Cmd+K | Open/close search |
| Arrow keys | Move the selection |
| Enter | Open the selected result |
| Escape | Close search |
