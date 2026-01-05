return {
  {
    "nvim-treesitter",

    lazy = false,

    after = function()
      require("nvim-treesitter").setup({})
    end,
  },
  {
    "nvim-treesitter-context",

    event = "DeferredUIEnter",

    before = function()
      require("lz.n").trigger_load("nim-treesitter")
    end,
  },
  {
    "nvim-treesitter-endwise",

    event = "DeferredUIEnter",

    before = function()
      require("lz.n").trigger_load("nim-treesitter")
    end,
  },
}
