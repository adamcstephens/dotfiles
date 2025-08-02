-- notifications
return {
  "fidget.nvim",

  event = "DeferredUIEnter",

  after = function()
    require("fidget").setup({})
  end,
}
