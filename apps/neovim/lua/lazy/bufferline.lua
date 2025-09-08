return {
  "bufferline.nvim",

  lazy = false,

  after = function()
    require("bufferline").setup({
      options = {
        color_icons = false,
        diagnostics = "nvim_lsp",
        diagnostics_update_on_event = true,
        indicator = {
          style = "underline",
        },
        numbers = "buffer_id",
        separator_style = "slant",
      },
    })
  end,
}
