return {
  {
    "blink-cmp-luasnip-choice",
    lazy = true,
  },
  {
    "blink.cmp",

    event = "InsertEnter",

    after = function()
      require("lz.n").trigger_load("blink-cmp-luasnip-choice")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { "~/.dotfiles/apps/neovim/snippets/lua" },
      })

      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if luasnip.choice_active() then
          return "<Cmd>lua require('luasnip').change_choice(1)<CR>"
        end
        return "<C-l>"
      end, { expr = true, desc = "Next snippet choice" })

      require("blink.cmp").setup({
        snippets = { preset = "luasnip" },
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
          default = { "lsp", "buffer", "snippets", "lua_snippets", "choice", "path" },
          per_filetype = {
            codecompanion = { "codecompanion" },
          },
          providers = {
            snippets = {
              module = "blink.cmp.sources.snippets.default",
              opts = {
                search_paths = { "~/.dotfiles/apps/neovim/snippets" },
              },
            },
            lua_snippets = {
              name = "LuaSnip",
              module = "blink.cmp.sources.snippets.luasnip",
            },
            choice = {
              name = "LuaSnip Choices",
              module = "blink-cmp-luasnip-choice",
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
