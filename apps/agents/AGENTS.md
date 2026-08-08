- **CRITICAL** I like to ask questions. When a question is asked, you should answer it, and stop. Do not edit files. Do not run commands that would modify/undo changes. Do not pass go. Do not collect $200.
- When writing commands to files, e.g. scripts or docs, always use the long version (--name) over short (-n) if available.

## My Global Definition of Done
- ticket claimed (when relevant)
- formatting done.
- tests pass.
- code committed with all ticket changes included
  - Prefer no or very short commit body
  - Ticket ID in the body (when relevant)
  - Assisted-By line always included
- *critical* After committing, stop and get user approval for completion.
- ticket marked complete once approved (when relevant)

## Coding Rules
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
- in a flake project (flake.nix at root), you can find a nixpkgs copy on the system by running `nix flake metadata`
- Always use `pkgs.fetchpatch` instead of vendoring patch files into the repo
- If a nix build fails, use the `nix log` command it outputs to view the full log.
