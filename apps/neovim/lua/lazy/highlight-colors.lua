return {
  "nvim-highlight-colors",

  cmd = "HighlightColors",

  after = function()
    require("nvim-highlight-colors").setup({
      render = "first_column",
    })
  end,
}
