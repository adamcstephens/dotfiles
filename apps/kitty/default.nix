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
      "${config.directory}/.dotfiles/bin/prj";
in
{
  packages = [
    pkgs.kitty.terminfo
  ]
  ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [ pkgs.kitty ];

  xdg.config.files."kitty/kitty.conf".text = ''
    include ${config.xdg.config.directory}/kitty/dotfiles.conf
    include ${config.xdg.config.directory}/kitty/os.conf

    # nix provided configs
    font_family ${config.dotfiles.gui.font.mono}
    map ctrl+shift+p launch --type=overlay-main ${prj}
    map super+shift+p launch --type=overlay-main ${prj} --remote
  '';

  xdg.config.files."kitty/dotfiles.conf".source = dotlib.source "apps/kitty/dotfiles.conf";
  xdg.config.files."kitty/os.conf".source = dotlib.source (
    if pkgs.stdenv.hostPlatform.isDarwin then "apps/kitty/macos.conf" else "apps/kitty/linux.conf"
  );

  # themes
  xdg.config.files."kitty/no-preference-theme.auto.conf".source =
    npins.vim-moonfly-colors + "/extras/moonfly-kitty.conf";

  xdg.config.files."kitty/dark-theme.auto.conf".source =
    npins.vim-moonfly-colors + "/extras/moonfly-kitty.conf";
  xdg.config.files."kitty/light-theme.auto.conf".source =
    npins."modus-themes.nvim" + "/extras/kitty/modus_operandi.conf";

  # smart-splits.nvim
  xdg.config.files."kitty/neighboring_window.py".source =
    pkgs.vimPlugins.smart-splits-nvim + "/kitty/neighboring_window.py";
  xdg.config.files."kitty/relative_resize.py".source =
    pkgs.vimPlugins.smart-splits-nvim + "/kitty/relative_resize.py";
  xdg.config.files."kitty/split_window.py".source =
    pkgs.vimPlugins.smart-splits-nvim + "/kitty/split_window.py";
}
