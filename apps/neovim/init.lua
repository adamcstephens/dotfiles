vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.cursorline = true

vim.cmd([[colorscheme modus]])

require("which-key").setup({})

-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>p", "<cmd> Telescope find_files<CR>")
vim.keymap.set("n", "<leader>b", "<cmd> Telescope buffers<CR>")

local builtin = require("telescope.builtin")
local utils = require("telescope.utils")
local find_jump = function() builtin.find_files({ cwd = utils.buffer_dir() }) end
vim.keymap.set("n", "<leader>j", find_jump)

require('rainbow-delimiters.setup').setup {}

require('Comment').setup()
require('gitsigns').setup()
require('neovim-project').setup({})
require('nvim-tmux-navigation').setup({
  keybindings = {
    left = "<C-h>",
    down = "<C-j>",
    up = "<C-k>",
    right = "<C-l>",
    last_active = "<C-\\>",
    next = "<C-Space>",
  }
})

-- Setup language servers.
local lspconfig = require('lspconfig')
require("lsp-format").setup {}

lspconfig.lua_ls.setup { on_attach = require("lsp-format").on_attach }
lspconfig.gopls.setup { on_attach = require("lsp-format").on_attach }
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
