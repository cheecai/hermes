---
name: planning-with-files
description: Manus-style file-based planning using task_plan.md, findings.md, and progress.md as persistent working memory. Use when asked to plan, break down, or organize multi-step projects, research tasks, or any work requiring 5+ tool calls. Supports session recovery.
---

# Planning with Files

**Purpose:** File-based planning to organize and track progress on complex tasks. Creates `task_plan.md`, `findings.md`, and `progress.md` as persistent working memory.

**Use when:** Asked to plan, break down, or organize multi-step projects, research tasks, or work requiring 5+ tool calls.

## Core Philosophy

```
Context Window = RAM (volatile, limited)
Filesystem     = Disk (persistent, unlimited)

→ Anything important gets written to disk.
```

## The 3 Core Files

| File | Purpose | When to Update |
|------|---------|----------------|
| `task_plan.md` | Phases, progress, decisions | After each phase |
| `findings.md` | Research, discoveries | After ANY discovery |
| `progress.md` | Session log, test results | Throughout session |

**Location:** Planning files go in **your project directory**, not the skill installation folder.

## First Step: Restore Context

Before doing anything else, check for planning files and restore context:

```bash
# Linux/macOS
$(command -v python3 || command -v python) ${CLAUDE_PLUGIN_ROOT}/scripts/session-catchup.py "$(pwd)"
```

If catchup shows unsynced context:
1. Run `git diff --stat` to see actual code changes
2. Read current planning files
3. Update planning files based on catchup + git diff
4. Proceed with task

## Quick Start

1. **Create `task_plan.md`** — Define phases, goals, status
2. **Create `findings.md`** — Record research and discoveries
3. **Create `progress.md`** — Log session activity and test results
4. **Re-read plan before decisions** — Refreshes goals in attention window
5. **Update after each phase** — Mark complete, log errors

## Critical Rules

### Rule 1: Create Plan First
Never start a complex task without `task_plan.md`. Non-negotiable.

### Rule 2: The 2-Action Rule
> "After every 2 view/browser/search operations, IMMEDIATELY save key findings to text files."

This prevents visual/multimodal information from being lost.

### Rule 3: Read Before Decide
Before major decisions, read the plan file. This keeps goals in your attention window.

### Rule 4: Update After Act
After completing any phase:
- Mark phase status: `in_progress` → `complete`
- Log any errors encountered
- Note files created/modified

### Rule 5: Log ALL Errors
Every error goes in the plan file. This builds knowledge and prevents repetition.

```markdown
## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
| FileNotFoundError | 1 | Created default config |
| API timeout | 2 | Added retry logic |
```

### Rule 6: Never Repeat Failures
```
if action_failed:
    next_action != same_action
```

### Rule 7: Continue After Completion
When all phases done but user requests additional work:
- Add new phases to `task_plan.md`
- Log a new session entry in `progress.md`
- Continue the planning workflow as normal

## The 3-Strike Error Protocol

```
ATTEMPT 1: Diagnose & Fix
→ Read error carefully
→ Identify root cause
→ Apply targeted fix

ATTEMPT 2: Alternative Approach
→ Same error? Try different method
→ Different tool? Different library?
→ NEVER repeat exact same failing action

ATTEMPT 3: Broader Rethink
→ Question assumptions
→ Search for solutions
→ Consider updating the plan

AFTER 3 FAILURES: Escalate to User
→ Explain what you tried
→ Share the specific error
→ Ask for guidance
```

## Read vs Write Decision Matrix

| Situation | Action | Reason |
|-----------|--------|--------|
| Just wrote a file | DON'T read | Content still in context |
| Viewed image/PDF | Write findings NOW | Multimodal → text before lost |
| Browser returned data | Write to file | Screenshots don't persist |
| Starting new phase | Read plan/findings | Re-orient if context stale |
| Error occurred | Read relevant file | Need current state to fix |
| Resuming after gap | Read all planning files | Recover state |

## The 5-Question Reboot Test

If you can answer these, your context management is solid:

| Question | Answer Source |
|----------|---------------|
| Where am I? | Current phase in task_plan.md |
| Where am I going? | Remaining phases |
| What's the goal? | Goal statement in plan |
| What have I learned? | findings.md |
| What have I done? | progress.md |
