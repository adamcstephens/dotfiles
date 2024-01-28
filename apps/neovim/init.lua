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

if vim.loop.os_uname().sysname ~= "Linux"
    or os.getenv("XDG_CURRENT_DESKTOP") ~= nil then
  require('auto-dark-mode').setup({
    update_interval = 5000,
    set_dark_mode = function()
      vim.opt.background = 'dark'
    end,
    set_light_mode = function()
      vim.opt.background = 'light'
    end,
  })
end

require('Comment').setup()
require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

require("elixir").setup({
  elixirls = { enable = true, cmd = "elixir-ls", },
  nextls = { enable = false, cmd = "nextls", },
})
require("focus").setup()
require('gitsigns').setup()
local lspconfig = require('lspconfig')
require('lualine').setup({
  options = { theme = "modus-vivendi" },
  sections = {
    lualine_c = { { 'filename', path = 1 } },
  }
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
require('nvim-highlight-colors').setup({
  render = "first_column",
})
require('nvim-highlight-colors').turnOff()
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
    -- ["<C-s>"] = "actions.select_vsplit",
    -- ["<C-h>"] = "actions.select_split",
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
})
require('rainbow-delimiters.setup').setup({})
require('remember').setup({})
local builtin = require("telescope.builtin")
require("tmux").setup({})
require('trouble').setup()
require("which-key").setup({})
require('whitespace-nvim').setup({})

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
    ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
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
require("copilot").setup {
  filetypes = {
    elixir = true,
    ["*"] = false,
  },
}

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

-- use modus auto light/dark, switch with vim.opt.background
vim.cmd('colorscheme modus')

-- mappings
--
-- map ctrl-a/e to begin/end of line
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")
vim.keymap.set("n", "<C-e>", "$")
vim.keymap.set("n", "<C-a>", "0")

vim.keymap.set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bb", function() builtin.buffers({ sort_lastused = true }) end, { desc = "Switch buffers" })
vim.keymap.set("n", "<leader>bd", function() vim.cmd("bdelete") end, { desc = "Delete" })
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

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })

-- auto commands
--
local autoid = vim.api.nvim_create_augroup("dotgroup", {
  clear = true
})
vim.api.nvim_create_autocmd('BufEnter', {
  desc = "show cursorline active",
  callback = function() vim.cmd('set cursorline') end,
  group = autoid
})
vim.api.nvim_create_autocmd('BufLeave', {
  desc = "hide cursorline inactive",
  callback = function() vim.cmd('set nocursorline') end,
  group = autoid
})
vim.api.nvim_create_autocmd('FocusGained', {
  desc = "update ssh auth sock in tmux",
  callback = function()
    if not vim.env.TMUX then return nil end

    local tmuxEnv = vim.gsplit(vim.fn.system('tmux showenv'), '\n')
    local tmuxEnvSSH = vim.iter(tmuxEnv):filter(function(v) return string.match(v, "SSH_AUTH_SOCK") end):totable()
    local tmuxEnvSSHAuthSock = (vim.split(tmuxEnvSSH[1], '='))[2]

    if vim.env.SSH_AUTH_SOCK ~= tmuxEnvSSHAuthSock then
      vim.env.SSH_AUTH_SOCK = tmuxEnvSSHAuthSock
    end
  end,
  group = autoid
})
vim.api.nvim_create_autocmd('FileType', {
  desc = "quit help with q",
  pattern = "help",
  callback = function()
    vim.keymap.set("", "q", function()
      vim.api.nvim_buf_delete(0, {})
    end, { buffer = true, noremap = true, })
  end,
  group = autoid,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  desc = "delete trailing whitespace",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    require('whitespace-nvim').trim()
    vim.fn.setpos(".", save_cursor)
  end
})

-- Setup language servers.
--
local languages = {
  fish = {
    require('efmls-configs.linters.fish'),
    require('efmls-configs.formatters.fish_indent')
  },
  sh = {
    require('efmls-configs.linters.shellcheck'),
    require('efmls-configs.formatters.shfmt'),
  },
}
lspconfig.efm.setup({
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
lspconfig.gopls.setup({})

require('ionide').setup({})
vim.g["fsharp#lsp_auto_setup"] = 0

require('lspconfig')['hls'].setup({
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

lspconfig.lua_ls.setup({
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
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt", "--quiet" },
      },
      nix = {
        flake = {
          autoArchive = true,
          autoEvalInputs = true,
        },
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
