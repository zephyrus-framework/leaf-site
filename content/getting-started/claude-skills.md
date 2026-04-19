---
title: Claude Code Skills
order: 5
---

# Claude Code Skills

If you use [Claude Code](https://claude.com/claude-code), you can install skills that give Claude deep knowledge of both Zephyrus and Leaf. This helps Claude assist you with building Leaf projects without guessing APIs or conventions.

## Installation

Clone the skills into your Claude Code skills directory:

```bash
git clone https://github.com/ophelios-studio/claude-skills.git ~/.claude/skills/ophelios
```

This installs two skills:

| Skill | Triggers on |
|-------|-------------|
| **zephyrus** | Projects using `zephyrus-framework/core`, attribute routing, controllers |
| **leaf** | Projects using `zephyrus-framework/leaf-core`, BuildCommand, LeafConfig |

## What the skills know

### Zephyrus skill

- Attribute routing (`#[Get]`, `#[Post]`, etc.)
- Controller patterns and `RenderResponses` trait
- Request/Response immutable objects
- Middleware pipeline
- Configuration system (`ConfigSection`)
- Localization and Translator
- Latte template engine

### Leaf skill

- `Kernel` extension points (`createController`, `registerControllers`)
- `BuildCommand` pipeline and hooks (`onPostBuild`, `addPaths`)
- Multi-locale build behavior (default locale at root)
- SEO generators (sitemap, robots, hreflang)
- `ContentLoader` and Markdown parsing
- `config.yml` structure and `LeafConfig` fields
- Dev server and live-reload

## Updating

Pull the latest skills:

```bash
cd ~/.claude/skills/ophelios && git pull
```

## Per-project installation

If you prefer to install skills for a specific project only:

```bash
cd my-project
mkdir -p .claude/skills
ln -s /path/to/claude-skills/leaf .claude/skills/leaf
```
