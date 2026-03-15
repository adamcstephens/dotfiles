default:
    just --list

format:
    cargo fmt
    nixfmt **/*.nix

lint:
    cargo clippy

test *args:
    cargo test {{ args }}

# Release: just release 0.3.0
release version:
    sed -i 's/^version = ".*"/version = "{{ version }}"/' Cargo.toml
    cargo generate-lockfile --offline
    jj commit --message "release {{ version }}" Cargo.*
    git tag -a "v{{ version }}" -m "release {{ version }}"
    git push origin "v{{ version }}"
