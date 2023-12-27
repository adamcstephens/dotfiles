{
  config,
  lib,
  pkgs,
  ...
}:
let
  dependencies = [ pkgs.lua-language-server ];

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
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
  };

  package = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
    neovimConfig
    // {
      wrapperArgs = neovimConfig.wrapperArgs ++ [
        "--prefix"
        "PATH"
        ":"
        "${lib.makeBinPath dependencies}"
      ];
    }
  );
in
{
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/neovim";
  home.packages = [ package ];
}
