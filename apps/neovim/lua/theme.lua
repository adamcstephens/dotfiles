if vim.loop.os_uname().sysname ~= "Linux"
    or os.getenv("XDG_CURRENT_DESKTOP") ~= nil then
  require('auto-dark-mode').setup({
    update_interval = 5000,
    set_dark_mode = function()
      vim.opt.background = 'dark'
      vim.cmd('colorscheme github_dark_colorblind')
    end,
    set_light_mode = function()
      vim.opt.background = 'light'
      vim.cmd('colorscheme github_light_colorblind')
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
  end,
})

require('nvim-highlight-colors').setup({
  render = "first_column",
})

require('nvim-highlight-colors').turnOff()

require('rainbow-delimiters.setup').setup({})

vim.cmd('colorscheme modus')
