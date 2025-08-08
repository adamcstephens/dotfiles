return {
  "smart-splits.nvim",

  lazy = false,

  after = function()
    require("smart-splits").setup({
      at_edge = "stop",
    })
  end,

  keys = {
    -- moving between splits
    { "<A-h>", require("smart-splits").move_cursor_left, mode = { "n", "i", "t" } },
    { "<A-j>", require("smart-splits").move_cursor_down, mode = { "n", "i", "t" } },
    { "<A-k>", require("smart-splits").move_cursor_up, mode = { "n", "i", "t" } },
    { "<A-l>", require("smart-splits").move_cursor_right, mode = { "n", "i", "t" } },

    -- resizing splits
    -- these keymaps will also accept a range,
    -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
    { "<S-Left>", require("smart-splits").resize_left, mode = { "n", "i", "t" } },
    { "<S-Down>", require("smart-splits").resize_down, mode = { "n", "i", "t" } },
    { "<S-Up>", require("smart-splits").resize_up, mode = { "n", "i", "t" } },
    { "<S-Right>", require("smart-splits").resize_right, mode = { "n", "i", "t" } },
  },
}
