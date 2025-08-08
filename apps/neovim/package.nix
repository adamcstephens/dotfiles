{
  full ? false,
  dotvimPlugin ? ./.,
  mnw,
  neovim,

  lib,
  pkgs, # for mnw
  stdenv,

  vimPlugins,

  bash-language-server,
  errcheck,
  fish-lsp,
  golangci-lint,
  golangci-lint-langserver,
  go-tools,
  biome,
  lua,
  lua-language-server,
  nixd,
  nodejs,
  nodePackages,
  ruff,
  shellcheck,
  shfmt,
  sqlfluff,
  sqlite,
  stylua,
  taplo,
  yaml-language-server,
}:

mnw.lib.wrap pkgs {
  inherit neovim;

  appName = "dotvim";

  aliases = [ "vim" ];
  providers = {
    ruby.enable = false;
    python3.enable = false;
  };

  initLua = ''
    vim.g.sqlite_clib_path = '${sqlite.out}/lib/libsqlite3.${if stdenv.isDarwin then "dylib" else "so"}'

    vim.opt.rtp:append("${dotvimPlugin}")

    require('dotinit')
    require('lz.n').load('lazy')
  '';

  plugins = {
    start =
      with vimPlugins;
      [
        lz-n

        editorconfig-nvim
        elixir-tools-nvim
        friendly-snippets
        fugitive
        nui-nvim
        nvim-web-devicons
        openingh-nvim
        plenary-nvim
        remember-nvim
        rustaceanvim
        smart-open-nvim
        sqlite-lua
        statuscol-nvim
        telescope-dap-nvim
        telescope-zf-native-nvim
        telescope-nvim
        telescope-undo-nvim
        trouble-nvim
        vim-dadbod
        vim-dadbod-completion
        vim-dadbod-ui
        vim-just
        vim-repeat
        which-key-nvim
        whitespace-nvim
        zk-nvim
      ]
      ++ (mnw.lib.npinsToPlugins pkgs ./npins/sources.json);

    opt =
      with vimPlugins;
      [
        actions-preview-nvim
        blink-cmp
        copilot-lua
        cyberdream-nvim
        diffview-nvim
        fidget-nvim
        lualine-nvim
        neogit
        nvim-dap-go
        nvim-highlight-colors
        nvim-treesitter-endwise
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        oil-nvim
        tiny-inline-diagnostic-nvim
        tmux-nvim
        toggleterm-nvim
        vim-illuminate
      ]
      ++ (mnw.lib.npinsToPlugins pkgs ./npins.lazy/sources.json);
  };

  extraBinPath =
    [ ]
    ++ lib.optionals full [
      errcheck
      golangci-lint
      golangci-lint-langserver
      go-tools

      bash-language-server
      biome
      fish-lsp
      lua
      lua-language-server
      nixd
      nodejs
      nodePackages.prettier
      nodePackages.vscode-json-languageserver
      ruff
      shellcheck
      shfmt
      sqlfluff
      stylua
      taplo
      yaml-language-server
    ];
}
