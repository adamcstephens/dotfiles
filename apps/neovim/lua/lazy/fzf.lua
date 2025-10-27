-- notifications
return {
  "fzf-lua",

  event = "DeferredUIEnter",

  after = function()
    local actions = require("fzf-lua").actions
    require("fzf-lua").setup({
      "fzf-native",
      actions = {
        files = {
          ["ctrl-q"] = { fn = actions.file_sel_to_qf, prefix = "select-all" },
          ["ctrl-s"] = actions.file_vsplit,
          ["ctrl-t"] = actions.file_tabedit,
          ["ctrl-x"] = actions.file_split,
          ["enter"] = actions.file_edit,
        },
      },
    })
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
      "<leader>lr",
      function()
        require("fzf-lua").lsp_references({})
      end,
      desc = "file picker",
    },
    {
      "<leader>r",
      function()
        require("fzf-lua").live_grep_native({})
      end,
      desc = "file picker",
      mode = { "n" },
    },
    {
      "<leader>r",
      function()
        require("fzf-lua").grep_visual({})
      end,
      desc = "file picker",
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
