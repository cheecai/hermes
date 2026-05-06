---
name: brainstorming
description: "Turn ideas into fully formed designs and specs through collaborative dialogue. Design-first workflow: explore, clarify, propose approaches, write spec, get approval, hand off to writing-plans. Use when the user wants to design something before implementing."
---

# Brainstorming

**Purpose:** Help turn ideas into fully formed designs and specs through collaborative dialogue.

**Core Rule:** Do NOT invoke any implementation skill, write code, scaffold projects, or take implementation action until you have presented a design and received user approval.

## Anti-Pattern to Avoid

> "This Is Too Simple To Need A Design"

Every project goes through this process. A todo list, single-function utility, config change — all of them. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple projects), but you MUST present it and get approval.

## 9-Step Checklist

1. **Explore project context** — check files, docs, recent commits
2. **Offer visual companion** (if topic involves visual questions) — must be its own message
3. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
4. **Propose 2-3 approaches** — with trade-offs and your recommendation
5. **Present design** — in sections scaled to complexity, get user approval after each section
6. **Write design doc** — save to `docs/superpowers/specs/YYYY-MM-DD--design.md` and commit
7. **Spec self-review** — quick inline check for placeholders, contradictions, ambiguity, scope
8. **User reviews written spec** — ask user to review spec file before proceeding
9. **Transition to implementation** — invoke `writing-plans` skill to create implementation plan

## Process Flow

```
Explore project context → Visual questions ahead?
                            ↓ yes               ↓ no
                    Offer Visual Companion → Ask clarifying questions
                            ↓
                    Propose 2-3 approaches → Present design sections
                            ↓
                    User approves design? → no → revise
                            ↓ yes
                    Write design doc → Spec self-review (fix inline)
                            ↓
                    User approves spec? → changes → rewrite
                            ↓ approved
                    Invoke writing-plans skill (TERMINAL STATE)
```

**Terminal state:** invoking `writing-plans`. Do NOT invoke `frontend-design`, `mcp-builder`, or any other implementation skill.

## The Process: Understanding the Idea

- Check current project state first (files, docs, recent commits)
- **Scope assessment:** If request describes multiple independent subsystems, flag immediately. Help decompose into sub-projects first.
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible
- Focus on: purpose, constraints, success criteria

## Exploring Approaches

- Propose 2-3 different approaches with trade-offs
- Present conversationally with recommendation and reasoning
- Lead with recommended option and explain why

## Presenting the Design

- Scale each section to its complexity (few sentences → 200-300 words)
- Ask after each section if it looks right
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify

## Design for Isolation and Clarity

Break into smaller units that:
- Each have one clear purpose
- Communicate through well-defined interfaces
- Can be understood and tested independently

**For each unit, you should answer:**
- What does it do?
- How do you use it?
- What does it depend on?

**Test:** Can someone understand a unit without reading its internals? Can you change internals without breaking consumers?

## Spec Self-Review Checklist

After writing the spec document, check for:
1. **Placeholder scan** — Any "TBD", "TODO", incomplete sections, vague requirements? Fix them.
2. **Internal consistency** — Do sections contradict? Does architecture match feature descriptions?
3. **Scope check** — Is this focused enough for a single implementation plan?
4. **Ambiguity check** — Could any requirement be interpreted two ways?

Fix issues inline and move on.

## User Review Gate

> "Spec written and committed to `docs/superpowers/specs/`. Please review it and let me know if you want to make any changes before we start writing out the implementation plan."

Wait for user response. If changes requested, make them and re-run review loop.

## Key Principles

- **One question at a time** — Don't overwhelm
- **Multiple choice preferred** — Easier to answer than open-ended
- **YAGNI ruthlessly** — Remove unnecessary features
- **Explore alternatives** — Always propose 2-3 approaches
- **Incremental validation** — Present design, get approval before moving on
- **Be flexible** — Go back and clarify when something doesn't make sense

## Visual Companion

Browser-based companion for mockups, diagrams, and visual options. Full guide in `references/visual-companion.md`.

**⚠️ Environment note:** The visual companion requires `scripts/start-server.sh` from the original repo. In Hermes, the browser component is NOT available. Work remains in the terminal. Do NOT offer the browser companion — skip to Step 3 (clarifying questions).

**Offering the companion (must be its own message):**
> "Some of what we're working on might be easier to explain if I can show it to you in a web browser. I can put together mockups, diagrams, comparisons, and other visuals as we go. This feature is still new and can be token-intensive. Want to try it? (Requires opening a local URL)"
