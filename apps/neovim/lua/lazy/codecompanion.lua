return {
  "codecompanion.nvim",

  cmd = { "CodeCompanionChat" },

  after = function()
    require("codecompanion").setup({})
  end,
}
