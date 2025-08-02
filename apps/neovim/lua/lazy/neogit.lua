-- notifications
return {
  "neogit",

  keys = {
    {
      "<leader>g",
      function()
        require("neogit").open()
      end,
      desc = "Open Neogit",
    },
  },

  after = function()
    require("neogit").setup()
  end,
}
