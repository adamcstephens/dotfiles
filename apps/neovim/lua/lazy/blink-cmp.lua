return {
  {
    "blink.cmp",

    event = "InsertEnter",

    after = function()
      require("blink.cmp").setup({
        completion = {
          ghost_text = { enabled = true },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
        },
        keymap = {
          preset = "enter",

          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
        },
        sources = {
          default = { "lsp", "buffer", "snippets", "path" },
          per_filetype = {
            codecompanion = { "codecompanion" },
          },
          providers = {
            snippets = {
              opts = {
                search_paths = {
                  "~/.dotfiles/apps/neovim/snippets",
                },
              },
            },
            codecompanion = {
              name = "CodeCompanion",
              module = "codecompanion.providers.completion.blink",
              enabled = true,
              score_offset = 10,
              async = true,
            },
          },
        },
      })
    end,
  },
}
