{
  full ? false,
  mnw,
  neovim,

  callPackage,
  lib,
  pkgs,
  stdenv,

  vimPlugins,
  vimUtils,

  jq,
  errcheck,
  golangci-lint,
  golangci-lint-langserver,
  go-tools,
  biome,
  efm-langserver,
  lua,
  lua-language-server,
  nil,
  nixd,
  nodejs,
  nodePackages,
  ruff,
  shellcheck,
  shfmt,
  sqlfluff,
  sqlite,
  stylua,
  tree-sitter,
}:
let
  pins = import ./npins;
  pins-ext = import ./npins-ext;
  npinsPlugins = lib.mapAttrsToList (name: src: (vimUtils.buildVimPlugin { inherit name src; })) pins;

  nvim-treesitter-nu = callPackage ./nvim-treesitter-nu.nix {
    inherit (tree-sitter) buildGrammar;
    src = pins-ext.tree-sitter-nu;
  };
in

mnw.lib.wrap pkgs {
  inherit neovim;

  appName = "dotvim";

  withPython3 = false;
  extraPython3Packages = _: [ ];
  withRuby = false;
  vimAlias = true;

  initLua = ''
    vim.g.sqlite_clib_path = '${sqlite.out}/lib/libsqlite3.${if stdenv.isDarwin then "dylib" else "so"}'

    vim.opt.rtp:append("${pins-ext.tree-sitter-nu}")

    require('dotinit')
  '';

  plugins =
    with vimPlugins;
    [
      ./.

      actions-preview-nvim
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      conform-nvim
      copilot-lua
      copilot-cmp
      direnv-vim
      editorconfig-nvim
      efmls-configs-nvim
      elixir-tools-nvim
      fidget-nvim
      friendly-snippets
      fugitive
      gitsigns-nvim
      Ionide-vim
      lualine-nvim
      luasnip
      modus-themes-nvim
      neogit
      nui-nvim
      nvim-cmp
      nvim-dap
      nvim-dap-go
      nvim-highlight-colors
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      (nvim-treesitter.withPlugins (plugins: [ nvim-treesitter-nu ]))
      nvim-surround
      nvim-web-devicons
      oil-nvim
      rainbow-delimiters-nvim
      remember-nvim
      rustaceanvim
      smart-splits-nvim
      sqlite-lua
      telescope-dap-nvim
      telescope-zf-native-nvim
      telescope-nvim
      telescope-undo-nvim
      tmux-nvim
      trouble-nvim
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui
      vim-illuminate
      vim-just
      vim-matchup
      which-key-nvim
      whitespace-nvim
    ]
    ++ npinsPlugins;

  extraBinPath =
    [ jq ]
    ++ lib.optionals full [
      errcheck
      golangci-lint
      golangci-lint-langserver
      # ineffassign
      go-tools

      biome
      efm-langserver
      lua
      lua-language-server
      nil
      nixd
      nodejs
      nodePackages.vscode-json-languageserver
      ruff
      shellcheck
      shfmt
      sqlfluff
      stylua
    ];
}
