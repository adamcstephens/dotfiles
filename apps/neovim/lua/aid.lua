-- cmp
--
local cmp = require('cmp')
cmp.setup({
  experimental = {
    ghost_text = true
  },
  mapping = {
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<CR>"] = cmp.mapping.confirm({ select = false, }),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
  })
})

-- formatting
--
require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})


-- llm
--
require("copilot").setup {
  filetypes = {
    elixir = true,
    ["*"] = false,
  },
}

-- lsp
--
require("actions-preview").setup {
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
}

-- snip
--

local luasnip = require('luasnip')
-- load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()
-- load my snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.dotfiles/apps/vscodium/snippets", })

vim.keymap.set({ "i" }, "<C-s>", function() luasnip.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })
