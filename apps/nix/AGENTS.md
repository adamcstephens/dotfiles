- All commits MUST have a trailer with Assisted-By.
  - Use the format `Assisted-By: <Model> <Thinking Effort> in <Harness>/<version>`
- You MUST NEVER interact with Issues or Pull Requests without explicit direction to do so.

### Working with nixpkgs

You SHOULD avoid using nix3 subcommands against the local directory. This slows down actions by
forcing flake copying to /nix/store. This holds for any command that takes a flake target when
evaluating or building in the nixpkgs directory.

Good: `nix build -f . incus`
Bad: `nix build .#incus`
