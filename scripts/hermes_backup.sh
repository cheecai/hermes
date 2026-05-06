#!/bin/bash
# hermes_backup.sh — Run from ~/hermes
# Compares current state to last backup, generates growth.log, commits and pushes

set -e

cd ~/hermes

# Snapshot current files
SNAPSHOT=$(mktemp)
git ls-files > "$SNAPSHOT"

LAST_SNAPSHOT="growth.log.last"
LOG="growth.log"

# Generate growth log
{
    echo "# Growth Log — $(date '+%Y-%m-%d %H:%M %Z')"
    echo ""

    # Files added
    if [ -f "$LAST_SNAPSHOT" ]; then
        ADDED=$(comm -23 <(sort "$SNAPSHOT") <(sort "$LAST_SNAPSHOT") | grep -v '^$' || true)
        REMOVED=$(comm -13 <(sort "$SNAPSHOT") <(sort "$LAST_SNAPSHOT") | grep -v '^$' || true)

        if [ -n "$ADDED" ]; then
            echo "## + Files Added"
            echo "$ADDED" | sed 's/^/  /'
            echo ""
        fi

        if [ -n "$REMOVED" ]; then
            echo "## - Files Removed"
            echo "$REMOVED" | sed 's/^/  /'
            echo ""
        fi
    fi

    # Skill diffs
    echo "## Skills Summary"
    ls -d skills/*/ 2>/dev/null | while read -r d; do
        echo "  - $(basename "$d"): $(wc -l < "$d/SKILL.md" 2>/dev/null || echo '?') lines"
    done
    echo ""

    # Cron jobs status
    echo "## Cron Jobs"
    if [ -f "cron/jobs.json" ]; then
        python3 -c "
import json, sys
from datetime import datetime
with open('cron/jobs.json') as f:
    data = json.load(f)
for j in data.get('jobs', []):
    n = j.get('name','')
    s = j.get('schedule', {}).get('display', j.get('schedule', {}).get('expr',''))
    st = j.get('last_status', 'never')
    lr = j.get('last_run_at', 'never')
    print(f'  - {n}: {s} | last: {st}')
" 2>/dev/null || echo "  (parse error)"
    fi
    echo ""

    # Memory diff (count entries)
    echo "## Memory"
    if [ -f "memory/memory.md" ]; then
        LINES=$(wc -l < "memory/memory.md")
        echo "  memory.md: $LINES lines"
    fi
    echo ""

    echo "---"
    cat "$LOG" 2>/dev/null || true

} > "$LOG.tmp"

# Check if anything meaningful changed
if [ -f "$LAST_SNAPSHOT" ] && [ -f "$LOG" ]; then
    if diff -q "$SNAPSHOT" <(cat "$LAST_SNAPSHOT" | git ls-files) >/dev/null 2>&1; then
        echo "No meaningful changes — skipping commit."
        rm -f "$SNAPSHOT" "$LOG.tmp"
        exit 0
    fi
fi

# Save snapshot and log
cp "$SNAPSHOT" "$LAST_SNAPSHOT"
mv "$LOG.tmp" "$LOG"

echo "Growth log written:"
cat "$LOG"
