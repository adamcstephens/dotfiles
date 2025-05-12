local snippets_path = "~/.dotfiles/apps/vscodium/snippets"

-- blink completion
require("blink.cmp").setup({
  completion = {
    ghost_text = { enabled = true },
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
  },
  keymap = {
    preset = "enter",

    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
  },
  sources = { providers = { snippets = { opts = { search_paths = { snippets_path } } } } },
})

-- builtin
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- copilot
--
require("copilot").setup({
  suggestion = {
    auto_trigger = false,
  },
})
require("CopilotChat").setup({})

-- formatting
--
require("conform").setup({
  format_after_save = {
    lsp_fallback = true,
  },
  formatters_by_ft = {
    direnv = { "shfmt" },
    dune = { "format-dune-file" },
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
      end
    end,
    sql = { "sqlfluff" },
    teal = { "stylua" },
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

-- lsp
--
require("actions-preview").setup({
  telescope = {
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.8,
      height = 0.9,
      prompt_position = "top",
      preview_cutoff = 20,
      preview_height = function(_, _, max_lines)
        return max_lines - 15
      end,
    },
  },
})
