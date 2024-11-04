-- use experiemental lua loader
vim.loader.enable()

-- map leader to <Space> before we do anything else
-- vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = ","

-- includes
--
require("aid")
require("auto")
require("lang")
require("org")
require("theme")

-- packages
--
-- split handling
-- require("focus").setup()
-- notifications
require("fidget").setup({})
require("gitsigns").setup()

require("move").setup({
  block = {
    enable = true,
    indent = true,
  },
  char = {
    enable = true,
  },
})
local neogit = require("neogit")
neogit.setup()
require("nvim-surround").setup({})
require("nvim-treesitter.configs").setup({
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
  textobjects = {
    lsp_interop = {
      enable = true,
      border = "none",
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
})
require("nvim-web-devicons").setup({})
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
require("remember").setup({})
require("smart-splits").setup({})

local builtin = require("telescope.builtin")
local open_with_trouble = require("trouble.sources.telescope").open
require("telescope").setup({
  defaults = {
    mappings = {
      i = { ["<c-q>"] = open_with_trouble },
      n = { ["<c-q>"] = open_with_trouble },
    },
  },
  pickers = {
    ["buffers"] = { sort_mru = true, ignore_current_buffer = true },
  },
})
require("telescope").load_extension("dap")
require("telescope").load_extension("orgmode")
require("telescope").load_extension("telescope-tabs")
require("telescope").load_extension("undo")
require("telescope").load_extension("zf-native")
require("telescope-tabs").setup({})

require("tmux").setup({
  -- use smart-splits for navigation
  navigation = {
    enable_default_keybindings = false,
  },
  resize = {
    enable_default_keybindings = false,
  },
})
require("trouble").setup()
require("which-key").setup({})
require("whitespace-nvim").setup({})

-- vim settings
--
-- force osc 52 to bypass checks since we use a supported terminal
-- vim.g.clipboard    = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--   },
-- }

vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.undofile = true
vim.opt.whichwrap = "<,>,[,]"

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext   = "v:lua.vim.treesitter.foldtext()"
vim.cmd("set nofoldenable")

-- mappings
--
-- map ctrl-a/e to begin/end of line
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")
vim.keymap.set("n", "<C-e>", "$")
vim.keymap.set("n", "<C-a>", "0")

-- moving between splits
vim.keymap.set("n", "<A-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<A-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<A-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<A-l>", require("smart-splits").move_cursor_right)
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set("n", "<C-S-h>", require("smart-splits").resize_left)
vim.keymap.set("n", "<C-S-j>", require("smart-splits").resize_down)
vim.keymap.set("n", "<C-S-k>", require("smart-splits").resize_up)
vim.keymap.set("n", "<C-S-l>", require("smart-splits").resize_right)
-- swapping buffers between windows
vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)

-- moves
vim.keymap.set("n", "<A-Down>", ":MoveLine(1)<CR>")
vim.keymap.set("n", "<A-Up>", ":MoveLine(-1)<CR>")
vim.keymap.set("v", "<A-Down>", ":MoveBlock(1)<CR>")
vim.keymap.set("v", "<A-Up>", ":MoveBlock(-1)<CR>")

-- vim.keymap.set("n", "<leader><leader>", function()
--   require("telescope").extensions.smart_open.smart_open({ cwd_only = true, })
-- end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bb", function()
  builtin.buffers({ sort_lastused = true })
end, { desc = "Switch buffers" })
vim.keymap.set("n", "<leader>bd", function()
  vim.cmd("bdelete")
end, { desc = "Delete" })
vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "dap toggle breakpoint" })
vim.keymap.set(
  "n",
  "<leader>dB",
  require("telescope").extensions.dap.list_breakpoints,
  { desc = "dap list breakpoints" }
)
vim.keymap.set("n", "<leader>dc", function()
  -- (Re-)reads launch.json if present
  if vim.fn.filereadable(".vscode/launch.json") then
    require("dap.ext.vscode").load_launchjs(nil, { lldb = { "rust" } })
  end
  require("dap").continue()
end, { desc = "dap continue (start)" })

vim.keymap.set("n", "<leader>dh", require("telescope").extensions.dap.commands, { desc = "dap commands" })
vim.keymap.set("n", "<leader>dr", require("dap").repl.open, { desc = "dap repl" })
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>g", neogit.open, { desc = "Open Neogit" })
vim.keymap.set("n", "<leader>hk", builtin.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>ho", builtin.help_tags, { desc = "Help Tags" })
vim.keymap.set("n", "-", oil.open, { desc = "Jump Files" })
vim.keymap.set("n", "<leader>j", oil.open, { desc = "Jump Files" })
vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions, { desc = "Code actions" })
vim.keymap.set("n", "<leader>lf", function()
  require("trouble").toggle("lsp_references")
end, { desc = "Find References" })
vim.keymap.set("n", "<leader>li", vim.lsp.buf.hover, { desc = "Show hover" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>r", builtin.live_grep, { desc = "Search" })
vim.keymap.set("v", "<leader>r", builtin.grep_string, { desc = "Search selection" })
vim.keymap.set("n", "<leader>s", function()
  local function starts_with(str, start)
    return str:sub(1, #start) == start
  end

  if starts_with(vim.api.nvim_buf_get_name(0), "oil:///") then
    vim.cmd("write")
  else
    vim.cmd("write ++p")
  end
end, { desc = "Save File" })
vim.keymap.set("n", "<leader>S", function()
  vim.cmd("noautocmd write ++p")
end, { desc = "Save File (No autocmd)" })
vim.keymap.set("n", "<leader>t", require("telescope-tabs").list_tabs, { desc = "Tabs" })
vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")

-- diagnostics
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble Toggle" })
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

vim.keymap.set("n", "<leader>xq", function()
  require("trouble").toggle("quickfix")
end)
vim.keymap.set("n", "<leader>xl", function()
  require("trouble").toggle("loclist")
end)
vim.keymap.set({ "n", "v" }, "<leader>y", builtin.registers, { desc = "Registers" })

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })

local ls = require("luasnip")
vim.keymap.set({ "i", "s" }, "<C-J>", function()
  ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function()
  ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })
