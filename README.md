# hermes

Cheecai's Hermes Agent — memory, skills, configurations, and growth log.

## Structure

```
hermes/
├── memory/           # Persistent memory entries (who I am, preferences, conventions)
├── skills/           # Installed skills (SKILL.md + reference files)
├── configs/          # Config snapshots (config.yaml, .env redacted)
├── cron/             # Cron job definitions
├── scripts/          # Automation scripts
├── growth.log        # Diff summary vs last backup
└── growth.log.last   # Previous growth.log for comparison
```

## Memory

See `memory/memory.md` and `memory/user-profile.md`.

## Skills

- `brainstorming/` — Design-first workflow (from obra/superpowers)
- `defuddle/` — Clean markdown extraction from web pages (from guanyang/antigravity-skills)
- `filesystem-context/` — Filesystem-as-scratchpad for context overflow (from guanyang/antigravity-skills)
- `planning-with-files/` — Manus-style file-based planning (from guanyang/antigravity-skills)
- `requesting-code-review/` — Pre-commit review, security scan, quality gates
- `systematic-debugging/` — 4-phase root cause debugging
- `test-driven-development/` — RED-GREEN-REFACTOR cycle
- `writing-plans/` — Implementation plans: bite-sized tasks, paths, code

## Cron Jobs

See `cron/jobs.json`. Active jobs:
- `macro_collect` — 07:50 & 16:50 daily
- `macro_morning_brief` — 00:00 daily
- `macro_evening_brief` — 09:00 daily
- `macro_weekly_report` — 10:00 every Monday
- `workspace_diff_backup` — 22:00 every Sunday

## GitHub Auth

- Account: cheecai
- Token scopes: read:org, repo, workflow
