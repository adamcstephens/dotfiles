{
  full ? false,
  dotvimPlugin ? ./.,
  mnw,
  neovim,

  lib,
  pkgs, # for mnw
  stdenv,

  vimPlugins,

  errcheck,
  golangci-lint,
  golangci-lint-langserver,
  go-tools,
  biome,
  efm-langserver,
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
  superhtml,
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

        cyberdream-nvim
        editorconfig-nvim
        efmls-configs-nvim
        elixir-tools-nvim
        fidget-nvim
        friendly-snippets
        fugitive
        lualine-nvim
        mini-pick
        neogit
        nui-nvim
        nvim-highlight-colors
        nvim-treesitter.withAllGrammars
        nvim-treesitter-endwise
        nvim-surround
        nvim-web-devicons
        openingh-nvim
        plenary-nvim
        rainbow-delimiters-nvim
        remember-nvim
        rustaceanvim
        smart-open-nvim
        sqlite-lua
        statuscol-nvim
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
        diffview-nvim
        copilot-lua
        nvim-dap-go
        oil-nvim
        tiny-inline-diagnostic-nvim
      ]
      ++ (mnw.lib.npinsToPlugins pkgs ./npins.lazy/sources.json);
  };

  extraBinPath =
    [ ]
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
      nixd
      nodejs
      nodePackages.prettier
      nodePackages.vscode-json-languageserver
      ruff
      shellcheck
      shfmt
      sqlfluff
      stylua
      superhtml
      taplo
      yaml-language-server
    ];
}
