{
  config,
  inputs,
  lib,
  npins,
  pkgs,
  ...
}:
let
  package = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fish;

  hjemSessionVariables = pkgs.runCommand "hjem-session-vars.fish" { } ''
    mkdir -vp $out/share/fish/vendor_conf.d
    (echo "function setup_hjem_session_vars;"
    ${pkgs.buildPackages.babelfish}/bin/babelfish \
    <${config.environment.loadEnv}
    echo "end"
    echo "setup_hjem_session_vars") > $out/share/fish/vendor_conf.d/hjem-session-vars.fish
  '';

  mkSource =
    source:
    if config.dotfiles.nixosManaged then
      ./. + "/${source}"
    else
      "${config.directory}/.dotfiles/apps/fish/${source}";

  commandNotFound = pkgs.writeShellApplication {
    name = "command-not-found";
    excludeShellChecks = [ "SC1091" ];
    text = ''
      source ${
        inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db
      }/etc/profile.d/command-not-found.sh
      command_not_found_handle "$@"
    '';
  };

  # we'll steal this from HM
  fishCommandNotFound = pkgs.writeTextFile {
    name = "fish-command-not-found";
    text = ''
      function __fish_command_not_found_handler --on-event fish_command_not_found
          ${lib.getExe commandNotFound} $argv
      end
    '';
    destination = "/share/fish/vendor_functions.d/__fish_command_not_found_handler.fish";
  };

  themeDump =
    category: source:
    pkgs.writeScriptBin "dotfiles-theme-builder"
      # fish
      ''
        #!${lib.getExe package}

        echo "[${category}]"
        source "${source}"
        fish_config theme dump
      '';

  theme = pkgs.runCommand "build-dotfiles-theme" { } ''
    echo "# name: dotfiles" >dotfiles.theme

    ${lib.getExe (themeDump "light" "${npins."modus-themes.nvim"}/extras/fish/modus_operandi.fish")} >>dotfiles.theme
    ${lib.getExe (themeDump "dark" "${npins.vim-moonfly-colors}/extras/moonfly.fish")} >>dotfiles.theme
    cp dotfiles.theme $out
  '';
in
{
  packages = [
    package
    hjemSessionVariables
    commandNotFound
    fishCommandNotFound
  ];

  xdg.config.files."fish/completions".source = mkSource "completions";
  xdg.config.files."fish/conf.d".source = mkSource "conf.d";
  xdg.config.files."fish/config.fish".source = mkSource "config.fish";
  xdg.config.files."fish/functions".source = mkSource "functions";
  xdg.config.files."fish/themes/dotfiles.theme".source = theme;
}
