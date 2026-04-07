- **CRITICAL** DO NOT under ANY circumstances jump to implementation when I'm asking questions, proposing ideas, or saying things like "is it possible to...", "what if we...", "could we...", "why does". No code edits, no file writes. Only discuss. Wait for an explicit "do it", "go ahead", "implement it", etc. before touching any code. This applies ALWAYS, even if the answer seems obvious.
- Don't add unnecessary shell chaining (`;`, `&&`, `| tail`, `2>&1`, `||`) to Bash tool commands. Run commands cleanly and use separate tool calls when needed.
- When writing commands to files, always use the long version (--name) over short (-n) if available.
- Always use `/usr/bin/env` when writing scripts

### Coding Rules
- NEVER add a dependency without permission. ALWAYS check you're adding the latest version when approved.

### JJ Repositories
- NEVER modify immutable jj commits without explicit permission. Create a new commit on top instead.
- Always start work on a clean jj commit.
- Always commit or describe/new when finishing work.

### Working with nix
- in a flake project (flake.nix at root), you can find a nixpkgs copy on the system by running `nix flake metadata`
- Always use `pkgs.fetchpatch` instead of vendoring patch files into the repo
- If a nix build fails, use the `nix log` command it outputs to view the full log.
