{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  dependencies = [
    pkgs.efm-langserver
    pkgs.lua
    pkgs.lua-language-server
    pkgs.nil
  ];
  pins = import ./npins;
  npinsPlugins =
    lib.mapAttrsToList (name: src: (pkgs.vimUtils.buildVimPlugin { inherit name src; }))
      pins;

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    plugins =
      with pkgs.vimPlugins;
      [
        actions-preview-nvim
        comment-nvim
        conform-nvim
        direnv-vim
        efmls-configs-nvim
        gitsigns-nvim
        lualine-nvim
        luasnip
        modus-themes-nvim
        neogit
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        nvim-surround
        nvim-web-devicons
        rainbow-delimiters-nvim
        remember-nvim
        telescope-nvim
        trouble-nvim
        vim-just
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

  package = pkgs.wrapNeovimUnstable inputs.neovim-nightly.packages.${pkgs.system}.neovim (
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
