default:
    just --list

format:
    cargo fmt
    nixfmt **/*.nix

lint:
    cargo clippy

run *args:
    cargo run -- {{ args }}

test *args:
    cargo test {{ args }}
