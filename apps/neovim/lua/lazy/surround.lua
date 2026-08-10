return {
  "nvim-surround",

  event = "DeferredUIEnter",

  before = function()
    require("lz.n").trigger_load("nvim-treesitter-textobjects")
  end,

  after = function()
    require("nvim-surround").setup({})
  end,
}
