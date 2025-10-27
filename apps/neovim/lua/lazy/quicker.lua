return {
  "quicker.nvim",

  event = "DeferredUIEnter",

  after = function()
    require("quicker").setup()
  end,

  keys = {
    {
      "<leader>q",
      function()
        require("quicker").toggle()
      end,
      desc = "toggle quickfix",
    },
    {
      "<leader>xl",
      function()
        require("quicker").toggle({ loclist = true })
      end,
      desc = "toggle loclist",
    },
  },
}
