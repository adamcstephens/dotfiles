{
  config,
  lib,
  pkgs,
  ...
}:
let
  dependencies = [ pkgs.lua-language-server ];
  pins = import ./npins;
  npinsPlugins =
    lib.mapAttrsToList (name: src: (pkgs.vimUtils.buildVimPlugin { inherit name src; }))
      pins;

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    plugins =
      with pkgs.vimPlugins;
      [
        comment-nvim
        gitsigns-nvim
        lsp-format-nvim
        modus-themes-nvim
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        nvim-surround
        rainbow-delimiters-nvim
        telescope-nvim
        vim-just
        vim-lastplace
        which-key-nvim
      ]
      ++ npinsPlugins;
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
