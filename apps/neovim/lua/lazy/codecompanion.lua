return {
  "codecompanion.nvim",

  cmd = { "CodeCompanionChat" },

  after = function()
    require("lz.n").trigger_load("codecompanion-history.nvim")
    require("lz.n").trigger_load("codecompanion-spinner.nvim")
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-haiku-4.5",
          },
        },
      },

      extensions = {
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface (auto resolved to a valid picker)
            picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Optional filter function to control which chats are shown when browsing
            chat_filter = nil, -- function(chat_data) return boolean end
            -- Customize picker keymaps (optional)
            -- picker_keymaps = {
            --   rename = { n = "r", i = "<M-r>" },
            --   delete = { n = "d", i = "<M-d>" },
            --   duplicate = { n = "<C-y>", i = "<C-y>" },
            -- },
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              adapter = "copilot",
              model = "gpt-4o",
              refresh_every_n_prompts = 3,
              max_refreshes = 3,
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,

            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gcs",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = "copilot",
                model = "gpt-4o",
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },

            -- Memory system (requires VectorCode CLI)
            -- memory = {
            --   -- Automatically index summaries when they are generated
            --   auto_create_memories_on_summary_generation = true,
            --   -- Path to the VectorCode executable
            --   vectorcode_exe = "vectorcode",
            --   -- Tool configuration
            --   tool_opts = {
            --     -- Default number of memories to retrieve
            --     default_num = 10,
            --   },
            --   -- Enable notifications for indexing progress
            --   notify = true,
            --   -- Index all existing memories on startup
            --   -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
            --   index_on_startup = false,
            -- },
          },
        },
        spinner = {},
      },
    })
  end,

  keys = {
    {
      "<leader>ac",
      function()
        require("codecompanion").toggle()
      end,
      desc = "toggle code companion chat",
    },
    {
      "<leader>aa",
      function()
        require("codecompanion").actions()
      end,
      desc = "code companion actions",
    },
  },
}
