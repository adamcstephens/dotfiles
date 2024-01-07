-- use experiemental lua loader
vim.loader.enable()

-- map leader to <Space> before we do anything else
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- packages
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

require('Comment').setup()
require("focus").setup()
require('gitsigns').setup()
require("lsp-format").setup({})
local lspconfig = require('lspconfig')
require('lualine').setup({
  options = { theme = "modus-vivendi" },
})

local luasnip = require('luasnip')
require("modus-themes").setup({
  dim_inactive = false,
  on_highlights = function(highlights, colors)
    highlights.NeogitBranch = { fg = colors.blue }
    highlights.NeogitRemote = { fg = colors.magenta }
    highlights.NeogitSectionHeader = { fg = colors.fg_main }
    highlights.NeogitChangeModified = { fg = colors.blue }

    highlights.NeogitHunkHeader = { bg = colors.bg_active }
    highlights.NeogitDiffContext = { fg = colors.fg_dim }
    highlights.NeogitDiffAdd = { bg = colors.bg_added, fg = colors.fg_added }
    highlights.NeogitDiffDelete = { bg = colors.bg_removed, fg = colors.fg_removed }

    highlights.NeogitHunkHeaderHighlight = { bg = colors.bg_active, bold = true }
    highlights.NeogitDiffContextHightlight = { bg = colors.bg_dim, fg = colors.fg }
    highlights.NeogitDiffAddHighlight = { bg = colors.bg_added, fg = colors.fg_added }
    highlights.NeogitDiffDeleteHighlight = { bg = colors.bg_removed, fg = colors.fg_removed }

    highlights.NeogitFilePath = { fg = colors.green_faint }
    highlights.NeogitCommitViewHeader = { fg = colors.blue }
  end,
})

local neogit = require('neogit')
neogit.setup()
require('neovim-project').setup({
  projects = {
    "~/.dotfiles",
    "~/git/*",
    "~/projects/*",
  },
})

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

require('nvim-web-devicons').setup({})
require('rainbow-delimiters.setup').setup({})
require('remember').setup({})
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")
require('trouble').setup()
require("which-key").setup({})

-- vim settings
--
-- vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.number     = true
vim.opt.undofile   = true
vim.opt.whichwrap  = "<,>,[,]"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr   = "nvim_treesitter#foldexpr()"
vim.cmd('set nofoldenable')

vim.cmd([[colorscheme modus]])

-- mappings
--
-- map ctrl-a/e to begin/end of line
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")
vim.keymap.set("n", "<C-e>", "$")
vim.keymap.set("n", "<C-a>", "0")

vim.keymap.set("n", "<leader><space>", function() builtin.buffers({ sort_lastused = true }) end,
  { desc = "Switch buffers" })
vim.keymap.set("n", "<leader>bb", function() builtin.buffers({ sort_lastused = true }) end, { desc = "Switch buffers" })
vim.keymap.set("n", "<leader>bd", function() vim.cmd("bdelete") end, { desc = "Delete" })
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>g", neogit.open, { desc = "Find Files" })
vim.keymap.set("n", "<leader>h", builtin.help_tags, { desc = "Help" })
vim.keymap.set("n", "<leader>j", function() builtin.find_files({ cwd = utils.buffer_dir() }) end, { desc = "Jump Files" })
vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions)
vim.keymap.set("n", "<leader>p", "<cmd> Telescope neovim-project history<CR>", { desc = "Project History" })
vim.keymap.set("n", "<leader>P", "<cmd> Telescope neovim-project discover<CR>", { desc = "Project Discover" })
vim.keymap.set("n", "<leader>r", builtin.live_grep, { desc = "Search" })
vim.keymap.set("n", "<leader>s", function() vim.cmd("write ++p") end, { desc = "Save File" })
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

-- auto commands
--
vim.api.nvim_create_autocmd('BufEnter', { callback = function() vim.cmd('set cursorline') end })
vim.api.nvim_create_autocmd('BufLeave', { callback = function() vim.cmd('set nocursorline') end })
vim.api.nvim_create_autocmd('FocusGained', {
  desc = "update ssh auth sock in tmux",
  callback = function()
    -- if not vim.env.TMUX then return nil end

    local tmuxEnv = vim.gsplit(vim.fn.system('tmux showenv'), '\n')
    local tmuxEnvSSH = vim.iter(tmuxEnv):filter(function(v) return string.match(v, "SSH_AUTH_SOCK") end):totable()
    local tmuxEnvSSHAuthSock = (vim.split(tmuxEnvSSH[1], '='))[2]

    if vim.env.SSH_AUTH_SOCK ~= tmuxEnvSSHAuthSock then
      vim.env.SSH_AUTH_SOCK = tmuxEnvSSHAuthSock
    end
  end
})

-- Setup language servers.
--
local languages = {
  fish = {
    require('efmls-configs.linters.fish'),
    require('efmls-configs.formatters.fish_indent')
  }
}
lspconfig.efm.setup({
  on_attach = require("lsp-format").on_attach,
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
})
lspconfig.gopls.setup({ on_attach = require("lsp-format").on_attach })
lspconfig.lua_ls.setup({
  on_attach = require("lsp-format").on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- global gitignore isn't processed
        ignoreDir = {
          ".direnv/",
        },
        useGitIgnore = true,
      }
    }
  }
})
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

-- snippets
--
require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.dotfiles/apps/vscodium/snippets", })
vim.keymap.set({ "i" }, "<C-s>", function() luasnip.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })
