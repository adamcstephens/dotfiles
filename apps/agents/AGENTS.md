- **CRITICAL** I like to ask questions. When a question is asked, you should answer it, and stop. Do not edit files.
- When writing commands to files, e.g. scripts or docs, always use the long version (--name) over short (-n) if available.

## Ticket Scope and Workflow
- Ticket scope follows user intent, not assistant activity. Track requested outcomes, not the steps taken to produce them.
- Interpret `veans prime` instructions to create or claim a ticket as applying when implementation begins or when the user explicitly requests a separately tracked investigation. Using veans for tracking does not require creating a ticket for every interaction.
- “Refine for a ticket” means review relevant code and produce or update one or more implementation tickets. Put refinement findings and plans in those tickets; never create a separate ticket for refining them.
- Questions, discussion, code review, and investigation do not automatically require new tickets. Use an existing outcome ticket when relevant.
- Before creating a ticket, check whether an existing ticket represents the requested outcome. Add findings, plans, and progress there.
- Refinement alone does not start implementation. Leave the implementation ticket in Todo unless instructed otherwise; do not move it to In Progress or In Review merely because refinement is underway or complete.
- Create subtasks only for independently assignable deliverables, not for reading code, planning, testing, or reporting progress.
- When the user asks a question, answer without creating or changing tickets unless they explicitly request that action.

## My Global Definition of Done
Work is not ready for review until the following are in place, and only *after* implementation:
- ticket claimed (when relevant)
- formatting done.
- tests pass.
- code committed with all ticket changes included
  - Prefer no or very short commit body
  - Ticket ID in the body (when relevant)
  - Assisted-By line with specific model name always included (Co-Authored-by *NEVER* included). Sample: `Assisted-By: OpenAI Codex GPT-5.6 Terra`
- if in a veans project, move to in-review
- stop for feedback and let the user move to Done

## Coding Rules
- Use red/green test-driven development.
- NEVER add a dependency without permission. ALWAYS check you're adding the
  latest version when approved.
  - A dependency is anything version-pinned that you did not write, in any
    file type: package manifests, flake inputs, container base images,
    GitHub Actions `uses:` refs, vendored scripts, curl-piped installers.
  - First-party publishers are not exempt. `actions/*` and official Docker
    images count exactly like any third-party package.
  - "Check the latest version" means running a command that reports it, not
    recalling one.
- Always use `/usr/bin/env` when writing scripts
- AVOID comments. Comment only a surprising *why*. No history or ticket refs. When in doubt default to no comment, or ask if unsure.
- AVOID defensive programming, discuss with me first before assuming backwards compatibility or handling all potential cases.

### Code Repositories
- Assume you're working in a jj repo by default, only falling back to git if needed.
- Always start work on a clean jj commit.
- Check jj state before creating a new change to avoid creating empty changes.

### Working with nix
- When nix is available, and a package is in nix, you can access its source by building its `<package.src` attribute. Use this by default whether working on nix-related things or not.
- in a flake project (flake.nix at root), you can find a nixpkgs copy on the system by running `nix flake metadata`
- Always use `pkgs.fetchpatch` instead of vendoring patch files into the repo
- If a nix build fails, use the `nix log` command it outputs to view the full log.
