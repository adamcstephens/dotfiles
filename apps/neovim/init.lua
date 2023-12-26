require("which-key").setup({})

-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>p", "<cmd> Telescope find_files<CR>")

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.nil_ls.setup {}
