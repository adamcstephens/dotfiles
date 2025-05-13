return {
  "oil.nvim",

  lazy = false,

  after = function()
    require("oil").setup({
      default_file_explorer = true,

      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        -- ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        -- ["<C-c>"] = "actions.close",
        -- ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      view_options = {
        show_hidden = true,
      },
    })
  end,

  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      desc = "Jump Files",
    },
    {
      "<leader>j",
      function()
        require("oil").open()
      end,
      desc = "Jump Files",
    },
  },
}
