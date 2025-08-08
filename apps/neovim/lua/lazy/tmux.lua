return {
  "tmux.nvim",

  lazy = false,

  after = function()
    -- use smart-splits for everything but copy_sync
    require("tmux").setup({
      navigation = {
        enable_default_keybindings = false,
      },
      resize = {
        enable_default_keybindings = false,
      },
      swap = {
        enable_default_keybindings = true,
      },
    })
  end,
}
