return {
  "modus-themes.nvim",

  lazy = false,

  after = function()
    require("modus-themes").setup({
      colors = {
        -- default is too little contrast in active line
        bg_highlight = "#dadada",
      },
    })
  end,
}
