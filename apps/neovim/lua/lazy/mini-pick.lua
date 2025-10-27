return {
  "mini.pick",

  lazy = false,

  after = function()
    require("mini.pick").setup({})
    vim.ui.select = require("mini.pick").ui_select
  end,
}
