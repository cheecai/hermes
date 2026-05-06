---
name: filesystem-context
description: Use the filesystem as a persistent overflow layer for agent context. Activates when tool outputs bloat the context window, state needs to persist across long trajectories, or sub-agents must share information without direct message passing.
---

# Filesystem-Based Context Engineering

Use the filesystem as the primary overflow layer for agent context because context windows are limited while tasks often require more information than fits in a single window.

**Core Principle:** Prefer **dynamic context discovery** (pulling relevant context on demand) over static inclusion, because static context consumes tokens regardless of relevance.

## When to Activate

- Tool outputs are bloating the context window
- Agents need to persist state across long trajectories
- Sub-agents must share information without direct message passing
- Tasks require more context than fits in the window
- Building agents that learn and update their own instructions
- Implementing scratch pads for intermediate results
- Terminal outputs or logs need to be accessible to agents

## Four Modes of Context Failure

| Mode | Problem | Solution |
|------|---------|----------|
| **Missing context** | Needed information is absent | Persist tool outputs and intermediate results to files |
| **Under-retrieved context** | Retrieved content fails to encapsulate what the agent needs | Structure files for targeted retrieval (grep-friendly formats, clear section headers) |
| **Over-retrieved context** | Retrieved content far exceeds what's needed, wasting tokens | Offload bulk content to files, return compact references |
| **Buried context** | Niche information hidden across many files | Combine glob + grep for structural search; semantic search for conceptual queries |

## The Static vs Dynamic Trade-off

**Static context** (system instructions, tool definitions, critical rules) consumes tokens on every turn regardless of relevance.

**Dynamic approach:** Include only minimal static pointers (names, one-line descriptions, file paths) and load full content with search tools when relevant.

**Trade-off:** Dynamic discovery requires the model to recognize when it needs more context. When in doubt, include critical safety or correctness constraints statically.

## Core Patterns

### Pattern 1: Filesystem as Scratch Pad

Redirect large tool outputs to files, extract a compact summary, return a file reference:

```
if len(output) < threshold:
    return output
file_path = f"scratch/{tool_name}_{timestamp}.txt"
write_file(file_path, output)
key_summary = extract_summary(output, max_tokens=200)
return f"[Output written to {file_path}. Summary: {key_summary}]"
```

**Result:** ~100 tokens in context vs 8000+ accessible on demand.

### Pattern 2: Plan Persistence

Write plans to filesystem in structured format so the agent can re-read them to restore awareness:

```yaml
# scratch/current_plan.yaml
objective: "Refactor authentication module"
status: in_progress
steps:
  - id: 1
    description: "Audit current auth endpoints"
    status: completed
  - id: 2
    description: "Design new token validation flow"
    status: in_progress
  - id: 3
    description: "Implement and test changes"
    status: pending
```

**Practice:** Re-read the plan at the start of each turn or after any context refresh — this acts as "manipulating attention through recitation."

### Pattern 3: Sub-Agent Communication via Filesystem

Route sub-agent findings through the filesystem. Each sub-agent writes directly to its own workspace directory; the coordinator reads files directly, preserving full fidelity:

```
workspace/
  agents/
    research_agent/
      findings.md
      sources.jsonl
    code_agent/
      changes.md
      test_results.txt
    coordinator/
      synthesis.md
```

**Critical:** Enforce per-agent directory isolation to prevent write conflicts and maintain clear ownership.

### Pattern 4: Dynamic Skill Loading

Store skills as files; include only skill names with brief descriptions in static context. Load full content with `read_file` when relevant.
