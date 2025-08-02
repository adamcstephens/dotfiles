return {
  "lualine.nvim",

  lazy = false,

  after = function()
    require("lualine").setup({
      options = { theme = "auto" },
      sections = {
        lualine_c = { { "filename", path = 1 } },
      },
    })
  end,
}
