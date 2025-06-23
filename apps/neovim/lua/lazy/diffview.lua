return {
  "diffview.nvim",

  cmd = { "DiffviewOpen" },

  after = function()
    require("diffview").setup({})
  end,
}
