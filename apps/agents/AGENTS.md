- **CRITICAL** I like to ask questions. When a question is asked, you should answer it, and stop. Do not edit files.
- When writing commands to files, e.g. scripts or docs, always use the long version (--name) over short (-n) if available.
- When you are asking questions, you should use the AskUserQuestion tool instead of sending as text questions.

## Veans
If `.veans.yml` exists at the repository root, read the `veans` skill before any ticket or implementation work. Otherwise, do not apply veans guidance.

## Global Implementation Workflow

### Before Review

After implementation:

- formatting done.
- tests pass.
- code committed with all changes included
  - Prefer no or very short commit body
  - Assisted-By line with specific model name always included (Co-Authored-by *NEVER* included)
    - Use the format `Assisted-By: <Model> <Thinking Effort> in <Harness>/<version>`
    - Sample: `Assisted-By: OpenAI GPT-6.1 Sol low in omp/18.5.1`

### Handoff

- stop for feedback

## Scope and Simplicity

- Implement only the requested behavior. Do not add adjacent features, speculative generality, compatibility layers, or unrelated cleanup.
- Prefer the smallest coherent solution using existing patterns. New abstractions must solve a present requirement, not a hypothetical future need.
- Add failure handling only for failures relevant to the requested behavior or required by an existing contract. Do not invent fallback behavior, silently swallow errors, or validate internal invariants repeatedly.
- If the change grows beyond the requested outcome, stop expanding it. Explain the concrete requirement driving the extra work and propose the simpler alternative.
- If additional scope seems necessary, distinguish **required for correctness** from **optional improvement**. State the consequence of omitting it and ask before implementing it.
- Ask the user when an unresolved requirement materially changes scope, complexity, or failure behavior. Do not guess or implement multiple possibilities to avoid asking. Resolve questions from existing code and documentation first; if they remain unresolved, pause the affected work and ask a focused question with your recommendation.

## Coding Rules
- Prefer red/green testing when an existing relevant test suite makes it straightforward. Keep tests proportionate to the change; for small script or configuration fixes, use focused command-line verification rather than adding a new test harness.
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
- If a `.jj` directory exists, read the `jujutsu` skill and use jj exclusively instead of git.
  - Always start work on a clean jj commit.
  - Check jj state before creating a new change to avoid creating empty changes.

### Working with nix
- When nix is available, and a package is in nix, you can access its source by building its `<package.src` attribute. Use this by default whether working on nix-related things or not.
- in a flake project (flake.nix at root), you can find a nixpkgs copy on the system by running `nix flake metadata`
- Always use `pkgs.fetchpatch` instead of vendoring patch files into the repo
- If a nix build fails, use the `nix log` command it outputs to view the full log.

### Commit messages

My default commit style is to use a concise, lowercase, scoped imperative title:

```text
<scope>: <verb> <object>
 ```

 Examples:

 ```text
tmux: open remote splits remotely
river: fix pointer cursor
omp: add puppeteer support
 ```

 Choose the primary affected component as the scope. Do not capitalize the title, omit the scope, or use generic titles such as 'Update configuration'.
