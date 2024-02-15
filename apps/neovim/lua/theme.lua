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

require('github-theme').setup({
  options = {
    styles = {
      comments = 'italic',
    }
  }
})

require('lualine').setup({
  options = { theme = "auto" },
  sections = {
    lualine_c = { { 'filename', path = 1 } },
  }
})

require("modus-themes").setup({
  dim_inactive = false,
  on_highlights = function(highlights, colors)
    -- default is too much blue
    highlights.Identifier = { fg = colors.fg_main }

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

    highlights.IlluminatedWordRead = { underline = true }
    highlights.IlluminatedWordWrite = { underline = true }
    highlights.IlluminatedWordText = { underline = true }
  end,
})

require('nvim-highlight-colors').setup({
  render = "first_column",
})

require('nvim-highlight-colors').turnOff()

require('rainbow-delimiters.setup').setup({})

require("timed-highlight").setup({
  highlight_timeout_ms = 2000
})

-- show matches of hovered word
require('illuminate').configure({
  providers = {
    'lsp',
    'treesitter',
  },
  case_insensitive_regex = false,
  delay = 100,
  large_file_cutoff = nil,
  large_file_overrides = nil,
  min_count_to_highlight = 1,
  under_cursor = true,
})

vim.cmd('colorscheme modus')
