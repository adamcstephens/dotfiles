{
  config,
  dotlib,
  inputs,
  lib,
  npins,
  pkgs,
  ...
}:
let
  package = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fish;

  homeManagerSessionVariables = pkgs.writeTextFile {
    name = "home-manager-session-vars.fish";
    destination = "/share/fish/vendor_conf.d/home-manager-session-vars.fish";
    text = ''
      function __dotfiles_setup_home_manager_session_vars
          ${lib.getExe pkgs.babelfish} < ${lib.escapeShellArg "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"} | source
      end
      __dotfiles_setup_home_manager_session_vars
      functions --erase __dotfiles_setup_home_manager_session_vars

      fish_add_path --global --path --prepend --move ${
        lib.escapeShellArgs [
          "${config.home.profileDirectory}/bin"
          "${config.home.profileDirectory}/sbin"
        ]
      }
    '';
  };

  mkSource = source: dotlib.source "apps/fish/${source}";

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

  # Keep the handler in fish's vendor functions without managing programs.fish.
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
    ${lib.getExe (themeDump "dark" ../../themes/moonfly/extras/moonfly.fish)} >>dotfiles.theme
    cp dotfiles.theme $out
  '';
in
{
  home.packages = [
    package
    homeManagerSessionVariables
    commandNotFound
    fishCommandNotFound
  ];

  xdg.configFile."fish/completions".source = mkSource "completions";
  xdg.configFile."fish/conf.d".source = mkSource "conf.d";
  xdg.configFile."fish/config.fish".source = mkSource "config.fish";
  xdg.configFile."fish/functions".source = mkSource "functions";
  xdg.configFile."fish/themes/dotfiles.theme".source = theme;
}
