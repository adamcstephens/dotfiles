return {
  "rainbow-delimiters.nvim",

  lazy = true,
  -- event = "DeferredUIEnter",

  after = function()
    require("rainbow-delimiters.setup").setup({})
  end,
}
