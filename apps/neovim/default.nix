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
    pkgs.hurl
    pkgs.lua
    pkgs.lua-language-server
    pkgs.jq
    pkgs.nil
    pkgs.nodejs
    pkgs.shellcheck
    pkgs.shfmt
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
        friendly-snippets
        gitsigns-nvim
        Ionide-vim
        lualine-nvim
        luasnip
        modus-themes-nvim
        neogit
        nui-nvim
        nvim-cmp
        nvim-highlight-colors
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        (nvim-treesitter.withPlugins (plugins: [ nvim-treesitter-nu ]))
        nvim-surround
        nvim-web-devicons
        oil-nvim
        rainbow-delimiters-nvim
        remember-nvim
        sqlite-lua
        telescope-nvim
        tmux-nvim
        trouble-nvim
        vim-just
        vim-matchup
        which-key-nvim
        whitespace-nvim
      ]
      ++ npinsPlugins;
    withPython3 = false;
    extraPython3Packages = _: [ ];
    withRuby = false;
    viAlias = true;
    vimAlias = true;

    customRC = ''
      let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.${
        if pkgs.stdenv.isDarwin then "dylib" else "so"
      }'
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
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    MANWIDTH = "999";
  };

  home.packages = [ package ];

  home.file.".config/nvim/init.lua".source =
    if config.dotfiles.nixosManaged then
      ./init.lua
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/neovim/init.lua";

  home.file.".config/nvim/lua".source =
    if config.dotfiles.nixosManaged then
      ./lua
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/neovim/lua";

  home.file.".config/nvim/queries/nu".source = pins-ext.tree-sitter-nu + "/queries/nu";
}
