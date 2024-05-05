{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  dependencies = [
    pkgs.biome
    pkgs.efm-langserver
    pkgs.lua
    pkgs.lua-language-server
    pkgs.jq
    pkgs.nil
    pkgs.nixd
    pkgs.nodejs
    pkgs.ruff
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.stylua
  ];

  pins = import ./npins;
  pins-ext = import ./npins-ext;
  npinsPlugins = lib.mapAttrsToList (
    name: src: (pkgs.vimUtils.buildVimPlugin { inherit name src; })
  ) pins;

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
        conform-nvim
        copilot-lua
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
        smart-splits-nvim
        sqlite-lua
        telescope-zf-native-nvim
        telescope-nvim
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
    withPython3 = false;
    extraPython3Packages = _: [ ];
    withRuby = false;
    vimAlias = true;

    luaRcContent = ''
      vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.${
        if pkgs.stdenv.isDarwin then "dylib" else "so"
      }'

      vim.opt.rtp:append("${pins-ext.tree-sitter-nu}")

      vim.opt.rtp:append("${
        if config.dotfiles.nixosManaged then ./. else "${config.home.homeDirectory}/.dotfiles/apps/neovim"
      }")

      require('dotinit')
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
}
