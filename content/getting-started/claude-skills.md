---
title: Claude Code Skills
order: 5
---

# Claude Code Skills

If you use [Claude Code](https://claude.com/claude-code), you can install skills that give Claude deep knowledge of both Zephyrus and Leaf. This helps Claude assist you with building Leaf projects without guessing APIs or conventions.

## Installation

Install the two skills for your user, so they are available in every project. You need Node.js for `npx`.

```bash
npx skills add ophelios-studio/skills --skill leaf --skill zephyrus -g -a claude-code -y
```

The skills are copied (not linked) into `~/.claude/skills/leaf` and `~/.claude/skills/zephyrus`. Claude Code picks them up from there.

| Skill | Triggers on |
|-------|-------------|
| **zephyrus** | Projects using `zephyrus-framework/core`, attribute routing, controllers |
| **leaf** | Projects using `zephyrus-framework/leaf-core`, BuildCommand, LeafConfig |

The `ophelios-studio/skills` repository holds other skills too. Run `npx skills add ophelios-studio/skills --list` to see them.

## What the skills know

### Zephyrus skill

- Bootstrap and strict `config.yml` configuration
- Attribute routing (`#[Get]`, `#[Post]`) and middleware
- Sessions, CSRF and the boot-time security wiring check
- Latte views and form validation
- Error reporting and the PostgreSQL layer (`Database`, `Broker`, `Entity`)
- Mail, testing and deployment, with a repro for every gotcha

### Leaf skill

- The two project tiers: Binary CLI and Composer
- The `leaf init|dev|build|eject` CLI and `config.yml`
- Content, template overrides and custom pages
- The build pipeline and post-build hooks
- Multi-locale output (default locale at root)
- SEO (sitemap, robots, canonical, hreflang), dev servers and deploying

## Updating

Update the installed skills to their latest versions:

```bash
npx skills update -g -y
```

## Per-project installation

If you prefer to install the skills for one project only, run the same command without `-g`, from the project folder:

```bash
cd my-project
npx skills add ophelios-studio/skills --skill leaf --skill zephyrus -a claude-code -y
```

This copies the skills into `my-project/.claude/skills/` and writes a `skills-lock.json` next to it. Update them with:

```bash
npx skills update -p -y
```
