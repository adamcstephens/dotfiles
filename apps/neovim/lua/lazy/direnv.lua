return {
  "direnv.nvim",

  after = function()
    require("direnv").setup({})
  end,
}
