return {
  "conform.nvim",

  event = "BufEnter",

  after = function()
    require("conform").setup({
      format_after_save = {
        lsp_fallback = true,
      },
      formatters_by_ft = {
        css = { "biome" },
        direnv = { "shfmt" },
        dune = { "format-dune-file" },
        -- elixir = { "mix" },
        -- heex = { "mix" },
        javascript = { "prettier" },
        json = { "biome" },
        kdl = { "kdlfmt" },
        lua = { "stylua" },
        just = { "just" },
        nix = { "nixfmt" },
        proto = { "buf" },
        python = function(bufnr)
          if require("conform").get_formatter_info("black", bufnr).available then
            return { "black" }
          elseif require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_lint", "ruff_format" }
          else
            return {}
          end
        end,
        sql = { "sqlfluff" },
        teal = { "stylua" },
        toml = { "taplo" },
        terraform = function()
          if vim.fn.executable("tofu") == 1 then
            return { "tofu_fmt" }
          elseif vim.fn.executable("terraform") == 1 then
            return { "terraform_fmt" }
          else
            return {}
          end
        end,
        typescript = { "prettier" },
        yaml = { "prettier" },
      },
    })

    require("conform").formatters.biome = {
      args = {
        "format",
        ("--config-path=" .. os.getenv("HOME") .. "/.dotfiles/apps/biome/"),
        "--stdin-file-path",
        "$FILENAME",
      },
    }
  end,
}
