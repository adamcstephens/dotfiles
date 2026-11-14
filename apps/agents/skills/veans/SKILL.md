---
name: veans
description: >-
  Apply veans ticket scope, workflow, and review requirements when `.veans.yml`
  exists at the repository root. Do not apply in repositories without that file.
---

# Veans

Apply this guidance only when `.veans.yml` exists at the repository root.

## Ticket Scope and Workflow

- Ticket scope follows user intent, not assistant activity. Track requested outcomes, not the steps taken to produce them.
- Interpret `veans prime` instructions to create or claim a ticket as applying when implementation begins or when the user explicitly requests a separately tracked investigation. Using veans for tracking does not require creating a ticket for every interaction.
- “Refine for a ticket” means review relevant code and produce or update one or more implementation tickets. Put refinement findings and plans in those tickets; never create a separate ticket for refining them. Never mark a ticket for review if it's only refinement.
- Questions, discussion, code review, and investigation do not automatically require new tickets. Use an existing implementation ticket when relevant.
- Before creating a ticket, check whether an existing ticket represents the requested outcome. Add findings, plans, and progress there or ask if unsure.
- Refinement alone does not start implementation. Leave the implementation ticket in Todo unless instructed otherwise; do not move it to In Progress or In Review merely because refinement is underway or complete. Only complete work goes up for review.
- Create subtasks only for independently assignable deliverables, not for reading code, planning, testing, or reporting progress.
- When the user asks a question, answer without creating or changing tickets unless they explicitly request that action.

## Implementation Workflow

These phases supplement the global Implementation Workflow.

### Before Implementation

- Find an existing ticket for the requested outcome, or create one if none exists, and claim it.

### Before Review

- code committed with all ticket changes included
  - Ticket ID in the body

### Handoff

- Move to In Review only after both the global and veans Before Review requirements are satisfied.
- stop for feedback and let the user move to Done
