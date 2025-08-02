return {
  {
    "nvim-treesitter",

    lazy = false,

    after = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = "v",
            node_decremental = "V",
          },
        },
        matchup = {
          enable = true,
        },
        textobjects = {
          lsp_interop = {
            enable = true,
            border = "none",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter-context",

    event = "DeferredUIEnter",

    before = function()
      require("lz.n").trigger_load("nim-treesitter")
    end,
  },
  {
    "nvim-treesitter-endwise",

    event = "DeferredUIEnter",

    before = function()
      require("lz.n").trigger_load("nim-treesitter")
    end,
  },
  {
    "nvim-treesitter-textobjects",

    event = "DeferredUIEnter",

    before = function()
      require("lz.n").trigger_load("nim-treesitter")
    end,

    after = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {},
      })
    end,
  },
}
