return {
  "smart-splits.nvim",

  lazy = false,

  after = function()
    local options = { at_edge = "stop" }

    if vim.env.TUIOS_SESSION then
      local function send(command, value)
        io.stdout:write("\27]7777;tuios-nvim-navigator;" .. command .. ";" .. value .. "\7")
        io.stdout:flush()
      end

      options.multiplexer_integration = false
      options.at_edge = function(context)
        send("focus", context.direction)
      end

      local group = vim.api.nvim_create_augroup("TuiosSmartSplits", { clear = true })
      vim.api.nvim_create_autocmd({ "VimResume", "FocusGained" }, {
        group = group,
        callback = function()
          send("state", "active")
        end,
      })
      vim.api.nvim_create_autocmd({ "VimSuspend", "VimLeavePre" }, {
        group = group,
        callback = function()
          send("state", "inactive")
        end,
      })
      send("state", "active")
    end

    require("smart-splits").setup(options)
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
