---
name: adr
description: >
  Skill for creating and managing Architecture Decision Records (ADRs).
  Use this skill whenever the user wants to document architectural or technical decisions as lightweight Markdown files.
  Triggers include: "write an ADR", "record this architecture decision", "document why we chose X",
  "I want to capture this tech decision", "create a decision record", or when retrospectively
  documenting an existing technology choice. Also use when helping update or supersede an existing ADR.
---

# Architecture Decision Record (ADR) Skill

## Overview

ADRs capture *why* a design or technology choice was made — not just what was decided.
One file per decision. Never delete old ADRs; update Status instead.

## File Layout

```
docs/adr/
├── 0001-use-hono-for-api.md
├── 0002-cloudflare-workers-deployment.md
└── ...
```

Numbers are zero-padded to 4 digits. Titles use kebab-case.

---

## Template

```markdown
# ADR-{NUMBER}: {Title}

## Status
{Proposed | Accepted | Deprecated | Superseded by ADR-XXXX}

## Date
{YYYY-MM-DD}

## Context
Why was this decision necessary? Describe the situation, constraints, and forces at play.
Write in present or past tense. Do not include the solution here.
Cover technical, organizational, and time constraints.

## Decision
What was decided? Use active voice and declarative tone ("We will adopt X").
A brief rationale is acceptable here.

## Alternatives Considered
Options that were evaluated but rejected, with a short reason for each.
Required when the decision involves meaningful trade-offs.

## Consequences
Impact and trade-offs of this decision.
Cover positive, negative, and neutral outcomes.
Note anything that may become a future constraint.

## References
- Related ADRs, issues, PRs, or external documentation
```

---

## Writing Guidelines

### Context
- Describe the situation as it was — constraints, pressures, requirements
- Do not mention the solution (that goes in Decision)
- Write with enough detail that a future reader can reconstruct the original context

### Decision
- Declarative and unambiguous: "We will use X", "We adopt Y"
- Include the primary rationale in 1–2 sentences if it aids clarity

### Alternatives Considered
- Only list options that were seriously evaluated and rejected
- Keep rejection reasons concise (1–2 sentences each)

### Consequences
- **Positive**: What is gained
- **Negative**: What is lost or accepted as cost
- **Neutral**: Changes or follow-up work required

---

## Status Values

| Status | Meaning |
|--------|---------|
| Proposed | Under discussion, not yet decided |
| Accepted | Decided and in effect |
| Deprecated | No longer applicable (explain why in body) |
| Superseded by ADR-XXXX | Replaced by another ADR |

**Do not delete deprecated or superseded ADRs.** Historical rationale has long-term value.

---

## Output Format

- Output as a Markdown file
- Filename: `{NUMBER}-{kebab-case-title}.md` (e.g. `0003-use-drizzle-orm.md`)
- Match the numbering of existing ADRs; default to `0001` if none exist
- Language: match the project's convention (English or Japanese)

---

## Common Patterns

### New technology selection
"Write an ADR for why we chose Hono over Express"
→ Full template: Context (why a framework decision was needed) + Decision + Alternatives + Consequences

### Retrospective documentation
"We're already on Cloudflare Workers but have no ADR for it"
→ Reconstruct Context from inferred or confirmed constraints, then fill the template

### Recording a change
"We're switching from PlanetScale to Turso — document it"
→ Propose superseding the old ADR + create a new one for the new decision

### PR / review context
"I want to attach this ADR to my PR"
→ Enrich Consequences from a reviewer's perspective