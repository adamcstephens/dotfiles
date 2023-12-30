-- packages
--
require('Comment').setup()
require('gitsigns').setup()
require("lsp-format").setup({})
local lspconfig = require('lspconfig')
require('neovim-project').setup({
  projects = {
    "~/.dotfiles",
    "~/git/*",
    "~/projects/*",
  },
})
require('nu').setup({})
require('nvim-surround').setup({})
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
require('rainbow-delimiters.setup').setup({})
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")
require("which-key").setup({})

-- vim settings
--
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.undofile = true

vim.cmd([[colorscheme modus]])

-- mappings
--
-- map ctrl-a/e to begin/end of line
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")
vim.keymap.set("n", "<C-e>", "$")
vim.keymap.set("n", "<C-a>", "0")

-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>j", function() builtin.find_files({ cwd = utils.buffer_dir() }) end)
vim.keymap.set("n", "<leader>p", "<cmd> Telescope neovim-project history<CR>")
vim.keymap.set("n", "<leader>P", "<cmd> Telescope neovim-project discover<CR>")
vim.keymap.set("n", "<leader>s", "<cmd> write<CR>")

-- Setup language servers.
--
lspconfig.lua_ls.setup({ on_attach = require("lsp-format").on_attach })
lspconfig.gopls.setup({ on_attach = require("lsp-format").on_attach })
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
lspconfig.nushell.setup({})
