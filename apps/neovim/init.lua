-- use experiemental lua loader
vim.loader.enable()

-- vim.opt.runtimepath:append(',~/.config/nvim/lua')

-- map leader to <Space> before we do anything else
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- includes
--
require("aid")
require("auto")
require("lang")
require("theme")

-- packages
--
require('Comment').setup()
-- split handling
require("focus").setup()
require('gitsigns').setup()

require('hurl').setup({
  show_notification = true,
  mode = "popup",
})

local neogit = require('neogit')
neogit.setup()
require('nvim-surround').setup({})
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "v",
      node_decremental = "V",
    },
  },
  matchup = {
    enable = true,
  },
})
require('nvim-web-devicons').setup({})
local oil = require("oil")
oil.setup({
  use_default_keymaps = false,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
    -- ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    -- ["<C-c>"] = "actions.close",
    -- ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  view_options = {
    show_hidden = true,
  },
})
require('remember').setup({})
local builtin = require("telescope.builtin")
require("tmux").setup({})
require('trouble').setup()
require("which-key").setup({})
require('whitespace-nvim').setup({})

-- vim settings
--
-- vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.number     = true
vim.opt.spell      = true
vim.opt.undofile   = true
vim.opt.whichwrap  = "<,>,[,]"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext   = "v:lua.vim.treesitter.foldtext()"
vim.cmd('set nofoldenable')


-- mappings
--
-- map ctrl-a/e to begin/end of line
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")
vim.keymap.set("n", "<C-e>", "$")
vim.keymap.set("n", "<C-a>", "0")

vim.keymap.set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open({ cwd_only = true, })
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bb", function() builtin.buffers({ sort_lastused = true }) end, { desc = "Switch buffers" })
vim.keymap.set("n", "<leader>bd", function() vim.cmd("bdelete") end, { desc = "Delete" })
vim.keymap.set("n", "<leader>dr", "<cmd>HurlRunnerAt<CR>", { desc = "Hurl Under Cursor" })
vim.keymap.set("n", "<leader>dR", "<cmd>HurlRunner<CR>", { desc = "Hurl File" })
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>g", neogit.open, { desc = "Open Neogit" })
vim.keymap.set("n", "<leader>hk", builtin.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>ho", builtin.help_tags, { desc = "Help Tags" })
vim.keymap.set("n", "<leader>j", oil.open, { desc = "Jump Files" })
vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions, { desc = "Code actions" })
vim.keymap.set("n", "<leader>lf", function() require("trouble").toggle("lsp_references") end,
  { desc = "Find References" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>r", builtin.live_grep, { desc = "Search" })
vim.keymap.set("v", "<leader>r", builtin.grep_string, { desc = "Search selection" })
vim.keymap.set("n", "<leader>s", function() vim.cmd("write ++p") end, { desc = "Save File" })
vim.keymap.set("n", "<leader>S", function() vim.cmd("noautocmd write ++p") end, { desc = "Save File (No autocmd)" })
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "<leader>y", builtin.registers, { desc = "Registers" })

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })
