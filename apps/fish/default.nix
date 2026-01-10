{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  homeManagerSessionVariables = pkgs.runCommand "hm-session-vars.fish" { } ''
    mkdir -vp $out/share/fish/vendor_conf.d
    (echo "function setup_hm_session_vars;"
    ${pkgs.buildPackages.babelfish}/bin/babelfish \
    <${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh
    echo "end"
    echo "setup_hm_session_vars") > $out/share/fish/vendor_conf.d/hm-session-vars.fish
  '';
in
{
  home.packages = [
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fish
    homeManagerSessionVariables
  ];

  xdg.configFile = lib.genAttrs' [ "completions" "conf.d" "config.fish" "functions" ] (
    source:
    lib.nameValuePair "fish/${source}" {
      source =
        if config.dotfiles.nixosManaged then
          ./. + "/${source}"
        else
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/fish/${source}";
    }
  );

  # xdg.configFile."fish/theme-dark.fish".source = npins.vim-moonfly-colors + "/extras/moonfly.fish";
  # xdg.configFile."fish/theme-light.fish".source =
  #   npins."modus-themes.nvim" + "/extras/fish/modus_operandi.fish";
}
