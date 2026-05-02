return {
  "whitespace.nvim",

  event = "DeferredUIEnter",

  after = function()
    require("whitespace-nvim").setup({})
  end,
}
