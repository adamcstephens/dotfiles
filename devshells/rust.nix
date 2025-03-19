{
  mkShell,
  pkgs,
}:
mkShell {
  packages = with pkgs; [
    cargo
    cmake
    openssl.dev
    pkg-config
    rustc
    rust-analyzer
    rustfmt
  ];

}
