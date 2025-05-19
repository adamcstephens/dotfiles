return {
  "direnv.nvim",

  lazy = false,

  after = function()
    require("direnv").setup({})
  end,
}
