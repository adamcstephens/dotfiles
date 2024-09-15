-- builtin
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- cmp
--
local cmp = require("cmp")
cmp.setup({
  experimental = {
    ghost_text = true,
  },
  mapping = {
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  },
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "copilot" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "path" },
  }),
})

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
    agent = {
      adapter = "copilot",
    },
  },
})

-- formatting
--
require("conform").setup({
  format_after_save = {
    lsp_fallback = true,
  },
  formatters_by_ft = {
    -- elixir = { "mix" },
    heex = { "mix" },
    javascript = { "biome" },
    json = { "biome" },
    lua = { "stylua" },
    nix = { "nixfmt" },
    python = { "ruff_lint", "ruff_format" },
    sql = { "sqlfluff" },
    teal = { "stylua" },
    terraform = { "tofu_fmt" },
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

-- llm
--
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },

  filetypes = {
    go = true,
    elixir = true,
    zig = true,
    ["*"] = false,
  },
})
require("copilot_cmp").setup()

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

-- snip
--

local luasnip = require("luasnip")
-- load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load({
  exclude = { "terraform" },
})
-- load my snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.dotfiles/apps/vscodium/snippets" })

vim.keymap.set({ "i" }, "<C-s>", function()
  luasnip.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })
