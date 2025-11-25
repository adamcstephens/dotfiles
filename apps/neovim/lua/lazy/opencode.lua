return {
  "opencode.nvim",

  keys = {
    {
      "<leader>as",
      function()
        require("opencode").select()
      end,
      desc = "opencode select",
    },
  },
}
