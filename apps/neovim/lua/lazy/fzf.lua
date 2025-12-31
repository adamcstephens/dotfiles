-- notifications
return {
  "fzf-lua",

  event = "DeferredUIEnter",

  after = function()
    local actions = require("fzf-lua").actions
    require("fzf-lua").setup({
      "fzf-tmux",
      actions = {
        files = {
          true,
          ["ctrl-q"] = { fn = actions.file_sel_to_qf, prefix = "select-all" },
        },
      },
      winopts = {
        preview = {
          flip_columns = 180,
        },
      },
    })

    require("fzf-lua").register_ui_select()
  end,

  keys = {
    {
      "<leader>bb",
      function()
        require("fzf-lua").buffers({})
      end,
      desc = "buffer picker",
    },
    {
      "<leader>f",
      function()
        require("fzf-lua").files({})
      end,
      desc = "file picker",
    },
    {
      "<leader>g",
      function()
        require("fzf-lua").git_status({})
      end,
      desc = "git status",
    },
    {
      "<leader>la",
      function()
        require("fzf-lua").lsp_code_actions({})
      end,
      desc = "lsp code actions",
      mode = { "n", "v" },
    },
    {
      "<leader>lr",
      function()
        require("fzf-lua").lsp_references({})
      end,
      desc = "lsp references",
    },
    {
      "<leader>r",
      function()
        require("fzf-lua").live_grep_native({})
      end,
      desc = "live grep",
      mode = { "n" },
    },
    {
      "<leader>r",
      function()
        require("fzf-lua").grep_visual({})
      end,
      desc = "grep selected",
      mode = { "v" },
    },
    {
      "<leader>xx",
      function()
        require("fzf-lua").workspace_diagnostics({})
      end,
      desc = "workspace diagnostics",
    },
  },
}
