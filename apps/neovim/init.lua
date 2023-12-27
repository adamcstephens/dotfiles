require("which-key").setup({})

-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>p", "<cmd> Telescope find_files<CR>")
vim.keymap.set("n", "<leader>b", "<cmd> Telescope buffers<CR>")

require('rainbow-delimiters.setup').setup {}

-- Setup language servers.
local lspconfig = require('lspconfig')
require("lsp-format").setup {}

lspconfig.gopls.setup {on_attach = require("lsp-format").on_attach}
lspconfig.nil_ls.setup {
  on_attach = require("lsp-format").on_attach,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt", "--quiet" },
      },
    },
  },
}
lspconfig.nushell.setup {}
