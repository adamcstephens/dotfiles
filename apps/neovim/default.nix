{
  config,
  lib,
  pkgs,
  ...
}:
let
  package = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
    pkgs.neovimUtils.makeNeovimConfig {
      plugins = with pkgs.vimPlugins; [
        lsp-format-nvim
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        rainbow-delimiters-nvim
        telescope-nvim
        which-key-nvim
      ];
      withPython3 = true;
      extraPython3Packages = _: [ ];
      withRuby = true;
      viAlias = true;
      vimAlias = true;

      customRC = ''
        luafile ${config.home.homeDirectory}/.dotfiles/apps/neovim/init.lua
      '';
    }
  );
in
{
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/neovim";
  home.packages = [ package ];
}