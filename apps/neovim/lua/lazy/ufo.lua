return {
  "nvim-ufo",

  event = "DeferredUIEnter",

  after = function()
    require("ufo").setup({
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    })
  end,
}
