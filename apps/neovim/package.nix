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
  dexter,
  errcheck,
  fish-lsp,
  fzf,
  golangci-lint,
  golangci-lint-langserver,
  go-tools,
  biome,
  lua,
  lua-language-server,
  nixd,
  nodejs,
  prettier,
  ruff,
  shellcheck,
  shfmt,
  sqlite,
  stylua,
  taplo,
  vscode-json-languageserver,
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
    vim.g.sqlite_clib_path = '${sqlite.out}/lib/libsqlite3.${
      if stdenv.hostPlatform.isDarwin then "dylib" else "so"
    }'

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
        friendly-snippets
        nui-nvim
        nvim-web-devicons
        plenary-nvim
        remember-nvim
        smart-open-nvim
        sqlite-lua
        statuscol-nvim
        nvim-treesitter.withAllGrammars
        vim-dadbod
        vim-dadbod-completion
        vim-dadbod-ui
        vim-fugitive
        vim-just
        vim-repeat
        which-key-nvim
        zk-nvim
      ]
      ++ (mnw.lib.npinsToPlugins pkgs ./npins/sources.json);

    opt =
      with vimPlugins;
      [
        blink-cmp
        diffview-nvim
        fidget-nvim
        fzf-lua
        nvim-dap
        nvim-dap-go
        nvim-treesitter-endwise
        oil-nvim
        openingh-nvim
        tiny-inline-diagnostic-nvim
        tmux-nvim
        toggleterm-nvim
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
      dexter
      fish-lsp
      fzf
      lua
      lua-language-server
      nixd
      nodejs
      prettier
      vscode-json-languageserver
      ruff
      shellcheck
      shfmt
      stylua
      taplo
      yaml-language-server
    ];
}
