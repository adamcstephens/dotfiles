{
  config,
  dotlib,
  lib,
  npins,
  pkgs,
  ...
}:
let
  prj =
    if (config.dotfiles.nixosManaged || pkgs.stdenv.hostPlatform.isDarwin) then
      lib.getExe (pkgs.callPackage ../../packages/prj.nix { })
    else
      "${config.home.homeDirectory}/.dotfiles/bin/prj";
in
{
  home.packages = [
    pkgs.kitty.terminfo
  ]
  ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [ pkgs.kitty ];

  xdg.configFile."kitty/kitty.conf".text = ''
    include ${config.xdg.configHome}/kitty/dotfiles.conf
    include ${config.xdg.configHome}/kitty/os.conf

    # nix provided configs
    font_family ${config.dotfiles.gui.font.mono}
    map ctrl+shift+p launch --type=overlay-main ${prj}
    map super+shift+p launch --type=overlay-main ${prj} --remote
  '';

  xdg.configFile."kitty/dotfiles.conf".source = dotlib.source "apps/kitty/dotfiles.conf";
  xdg.configFile."kitty/os.conf".source = dotlib.source (
    if pkgs.stdenv.hostPlatform.isDarwin then "apps/kitty/macos.conf" else "apps/kitty/linux.conf"
  );

  # themes
  xdg.configFile."kitty/no-preference-theme.auto.conf".source =
    dotlib.source "themes/moonfly/extras/moonfly-kitty.conf";

  xdg.configFile."kitty/dark-theme.auto.conf".source =
    dotlib.source "themes/moonfly/extras/moonfly-kitty.conf";
  xdg.configFile."kitty/light-theme.auto.conf".source =
    npins."modus-themes.nvim" + "/extras/kitty/modus_operandi.conf";
}
