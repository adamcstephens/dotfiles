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
    pkgs.nodejs-slim
  ];
  pins = import ./npins;
  pins-ext = import ./npins-ext;
  npinsPlugins =
    lib.mapAttrsToList (name: src: (pkgs.vimUtils.buildVimPlugin { inherit name src; }))
      pins;

  nvim-treesitter-nu = pkgs.callPackage ./nvim-treesitter-nu.nix {
    inherit (pkgs.tree-sitter) buildGrammar;
    src = pins-ext.tree-sitter-nu;
  };

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    plugins =
      with pkgs.vimPlugins;
      [
        actions-preview-nvim
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        comment-nvim
        conform-nvim
        copilot-lua
        direnv-vim
        efmls-configs-nvim
        elixir-tools-nvim
        gitsigns-nvim
        lualine-nvim
        luasnip
        modus-themes-nvim
        neogit
        nvim-cmp
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        (nvim-treesitter.withPlugins (plugins: [ nvim-treesitter-nu ]))
        nvim-surround
        nvim-web-devicons
        rainbow-delimiters-nvim
        remember-nvim
        telescope-nvim
        trim-nvim
        trouble-nvim
        vim-just
        vim-matchup
        which-key-nvim
      ]
      ++ npinsPlugins;
    withPython3 = false;
    extraPython3Packages = _: [ ];
    withRuby = false;
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
  home.file.".config/nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/neovim/init.lua";
  home.packages = [ package ];

  home.file.".config/nvim/queries/nu".source = pins-ext.tree-sitter-nu + "/queries/nu";
}
