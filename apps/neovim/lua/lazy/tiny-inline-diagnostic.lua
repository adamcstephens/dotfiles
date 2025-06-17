return {
  "tiny-inline-diagnostic.nvim",

  event = "DeferredUIEnter",

  after = function()
    -- https://github.com/rachartier/tiny-inline-diagnostic.nvim?tab=readme-ov-file#%EF%B8%8F-options
    require("tiny-inline-diagnostic").setup({
      preset = "classic",
    })
  end,
}
