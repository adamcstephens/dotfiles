return {
  "rainbow-delimiters.nvim",

  event = "DeferredUIEnter",

  after = function()
    require("rainbow-delimiters.setup").setup({})
  end,
}
