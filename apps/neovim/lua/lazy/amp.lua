return {
  "amp.nvim",

  cmd = "AmpStart",

  after = function()
    require("amp").setup({
      auto_start = false,
    })
  end,

  keys = {
    { "<leader>am", ":AmpStart<CR>", desc = "start amp", mode = { "n", "v" } },
  },
}
