{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./colors.nix

    ../apps/kitty
    ../apps/ssh
    ../apps/vscode
  ];

  dotfiles.apps.emacs = {
    package = lib.mkDefault pkgs.emacs29;
    patchForGui = lib.mkDefault true;
    full = lib.mkDefault true;
  };

  home.packages = [
    # crypt
    pkgs.age-plugin-yubikey
    pkgs.passage
    pkgs.rage

    # nix
    pkgs.alejandra
    inputs.nil.packages.${pkgs.system}.nil
    inputs.nix-index-database.packages.${pkgs.system}.comma-with-db
    pkgs.nix-output-monitor
    (pkgs.nixfmt.overrideAttrs (old: {
      version = "0.6.0-${builtins.substring 0 7 inputs.nixfmt-rfc.rev}";

      src = inputs.nixfmt-rfc;
    }))

    pkgs.difftastic
    pkgs.fx
    pkgs.gh
    pkgs.jq
    pkgs.just
    pkgs.pwgen
    pkgs.shfmt
    pkgs.unzip
  ];

  programs = {
    ssh.forwardAgent = true;
  };
}
