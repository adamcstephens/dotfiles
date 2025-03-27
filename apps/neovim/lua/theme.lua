-- default color
vim.cmd.colorscheme("moonfly")

-- enable auto dark
if vim.loop.os_uname().sysname ~= "Linux" or os.getenv("XDG_CURRENT_DESKTOP") ~= nil then
  require("auto-dark-mode").setup({
    update_interval = 5000,
    set_dark_mode = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("moonfly")
    end,
    set_light_mode = function()
      vim.opt.background = "light"
      vim.cmd.colorscheme("cyberdream")
    end,
  })
end

require("cyberdream").setup({
  variant = "light",
  italic_comments = true,
  colors = {
    -- default is too little contrast in active line
    bg_highlight = "#dadada",
  },
})

require("lualine").setup({
  options = { theme = "auto" },
  sections = {
    lualine_c = { { "filename", path = 1 } },
  },
})

require("nvim-highlight-colors").setup({
  render = "first_column",
})

require("nvim-highlight-colors").turnOff()

require("rainbow-delimiters.setup").setup({})

-- show matches of hovered word
require("illuminate").configure({
  providers = {
    "lsp",
    "treesitter",
  },
  case_insensitive_regex = false,
  delay = 100,
  large_file_cutoff = nil,
  large_file_overrides = nil,
  min_count_to_highlight = 1,
  under_cursor = true,
})
