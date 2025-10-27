return {
  "telescope.nvim",

  event = "DeferredUIEnter",

  after = function()
    require("telescope").setup({
      -- defaults = {
      --   preview = false,
      -- },
      pickers = {
        ["buffers"] = { sort_mru = true, ignore_current_buffer = true },
      },
    })
  end,
}
