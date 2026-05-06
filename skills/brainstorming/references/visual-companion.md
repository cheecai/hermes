# Visual Companion Guide

## Purpose

Browser-based visual brainstorming tool for showing mockups, diagrams, and options during AI-assisted development sessions.

## When to Use: Browser vs Terminal

### Use Browser When Content is Visual
- **UI mockups** — wireframes, layouts, navigation structures, component designs
- **Architecture diagrams** — system components, data flow, relationship maps
- **Side-by-side visual comparisons** — comparing layouts, color schemes, design directions
- **Design polish** — look and feel, spacing, visual hierarchy
- **Spatial relationships** — state machines, flowcharts, entity relationships

### Use Terminal When Content is Text/Tabular
- Requirements and scope questions
- Conceptual A/B/C choices (described in words)
- Tradeoff lists, pros/cons, comparison tables
- Technical decisions — API design, data modeling, architectural approach
- Clarifying questions

> **Key Distinction:** A question *about* a UI topic is not automatically a visual question.
> - "What kind of wizard do you want?" → Terminal (conceptual)
> - "Which of these wizard layouts feels right?" → Browser (visual)

> **Decision Rule:** `would the user understand this better by seeing it than reading it?`

## How It Works

### Architecture
- Server watches a directory for HTML files and serves the newest one to browser
- Write HTML content to `screen_dir`, user sees it and clicks to select options
- Selections recorded to `state_dir/events` as JSON lines

### Setup Requirements
```bash
# Session directory: .superpowers/brainstorm/<session-id>/
# Use --project-dir to persist files across restarts
--project-dir /path/to/project
```

> Without `--project-dir`, files go to `/tmp` and get cleaned up.

### Platform-Specific Launch Commands

**Claude Code (macOS/Linux):**
```bash
scripts/start-server.sh --project-dir /path/to/project
```

**Claude Code (Windows):** Use `run_in_background: true` on Bash tool call.

**Codex:** Auto-detects `CODEX_CI`, runs in foreground mode automatically.

**Gemini CLI:** Use `--foreground` and set `is_background: true`.

**Remote/Containerized Setups:**
```bash
scripts/start-server.sh --project-dir /path/to/project --host 0.0.0.0 --url-host localhost
```

## The Loop (6-Step Workflow)

### Step 1: Check & Write
- Verify `$STATE_DIR/server-info` exists (restart if needed)
- Server auto-exits after **30 minutes of inactivity**
- Write HTML to new file with **semantic filename** (e.g., `layout.html`, `visual-style.html`)
- **Never reuse filenames** — each screen = new file

### Step 2: Tell User
- Remind them of URL (every step)
- Brief text summary of what's on screen
- Ask them to respond in terminal

### Step 3: Read Events
- Read `$STATE_DIR/events` after user responds
- Merge with terminal text for full picture
- Terminal message = primary feedback; events = structured interaction data

### Step 4: Iterate or Advance
- If feedback changes current screen → write new file (e.g., `layout-v2.html`)
- Only advance when current step is validated

### Step 5: Unload When Returning to Terminal
```html
<div class="content">
  <p>Continuing in terminal...</p>
</div>
```

### Step 6: Repeat until done

## Writing Content Fragments

### Rules
- Write **only the content** — server adds frame, CSS, interactive infrastructure
- No `<html>`, `<body>`, `<head>`, or `<style>` tags

### Minimal Example
```html
<h2>Which layout works better?</h2>
<p>Consider readability and visual hierarchy</p>

<label>
  <input type="radio" name="layout" value="single">
  <h3>A — Single Column</h3>
  <p>Clean, focused reading experience</p>
</label>

<label>
  <input type="radio" name="layout" value="two-column">
  <h3>B — Two Column</h3>
  <p>Sidebar navigation with main content</p>
</label>
```

## Key Reminders

- [ ] Add `.superpowers/` to `.gitignore`
- [ ] Check server status before each write
- [ ] Use semantic, unique filenames per screen
- [ ] Always remind user of URL each turn
- [ ] Push "Continuing in terminal..." when leaving browser mode
