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
    {
      "<A-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      mode = { "n", "i", "t" },
    },
    {
      "<A-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      mode = { "n", "i", "t" },
    },
    {
      "<A-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      mode = { "n", "i", "t" },
    },
    {
      "<A-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      mode = { "n", "i", "t" },
    },

    -- resizing splits
    -- these keymaps will also accept a range,
    -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
    {
      "<S-Left>",
      function()
        require("smart-splits").resize_left()
      end,
      mode = { "n", "i", "t" },
    },
    {
      "<S-Down>",
      function()
        require("smart-splits").resize_down()
      end,
      mode = { "n", "i", "t" },
    },
    {
      "<S-Up>",
      function()
        require("smart-splits").resize_up()
      end,
      mode = { "n", "i", "t" },
    },
    {
      "<S-Right>",
      function()
        require("smart-splits").resize_right()
      end,
      mode = { "n", "i", "t" },
    },
  },
}
