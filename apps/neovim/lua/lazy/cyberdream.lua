return {
  "cyberdream.nvim",

  lazy = false,

  after = function()
    require("cyberdream").setup({
      variant = "light",
      italic_comments = true,
      colors = {
        -- default is too little contrast in active line
        bg_highlight = "#dadada",
      },
    })
  end,
}
