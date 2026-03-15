- CRITICAL: When I'm asking questions, proposing ideas, or saying things like "is it possible to...", "what if we...", "could we..." — NEVER implement. No code edits, no file writes. Only discuss. Wait for an explicit "do it", "go ahead", "implement it", etc. before touching any code. This applies even if the answer seems obvious.
- Don't add unnecessary shell chaining (`;`, `&&`, `| tail`, `2>&1`, `||`) to Bash tool commands. Run commands cleanly and use separate tool calls when needed.
- Don't chain bash commands,`>/dev/null; echo "exit: $?` is bad.
- Avoid using subshells
- Don't use `find` with `exec`
- Avoid using `find` with absolute paths
- Always prefer project local paths over absolute paths for the same destination
- When archiving openspec changes, always sync delta specs to main specs (skip the prompt, just do it).
- When writing commands to files, always use the long version (--name) over short (-n) if available.
- Always use `/usr/bin/env` when writing scripts
- NEVER delete or move git tags. Tags are immutable. If a tag is on the wrong commit, create a new one (e.g. v0.5.1) instead.
- NEVER modify immutable jj commits without explicit permission. Create a new commit on top instead.
- In a jj repo, before starting work on a new task, run `jj new` if the current change (`@`) is non-empty. If `@` is already empty, reuse it.

Working with nix:
- in a flake project (flake.nix at root), you can find a nixpkgs copy on the system by running `nix flake metadata`
- Always use `pkgs.fetchpatch` instead of vendoring patch files into the repo
