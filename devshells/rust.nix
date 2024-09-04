{
  mkShell,

  cargo,
  openssl,
  pkg-config,
  rustc,
  rust-analyzer,
  rustfmt,
}:
mkShell {
  packages = [
    cargo
    openssl.dev
    pkg-config
    rustc
    rust-analyzer
    rustfmt
  ];

}
