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
  fzf,
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
        plenary-nvim
        remember-nvim
        smart-open-nvim
        sqlite-lua
        statuscol-nvim
        nvim-treesitter.withAllGrammars
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
        blink-cmp
        copilot-lua
        cyberdream-nvim
        diffview-nvim
        fidget-nvim
        fzf-lua
        neogit
        nvim-dap
        nvim-dap-go
        nvim-highlight-colors
        nvim-treesitter-endwise
        nvim-treesitter-textobjects
        oil-nvim
        openingh-nvim
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
      fzf
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
