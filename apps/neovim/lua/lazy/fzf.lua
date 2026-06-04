-- notifications
return {
  {
    "fzf-lua",

    event = "DeferredUIEnter",

    after = function()
      require("lz.n").trigger_load("fzf-lua-frecency.nvim")
      require("fzf-lua-frecency").setup()

      local actions = require("fzf-lua").actions
      require("fzf-lua").setup({
        "fzf-tmux",
        actions = {
          files = {
            true,
            ["ctrl-q"] = { fn = actions.file_sel_to_qf, prefix = "select-all" },
          },
        },
        fzf_opts = { ["--tmux"] = "center,90%,90%,border-native" },
        winopts = {
          preview = {
            flip_columns = 180,
          },
        },
      })

      require("fzf-lua").register_ui_select()

      local fzf_lua = require("fzf-lua")

      -- jj status
      fzf_lua.jj_status = function(opts)
        opts = opts or {}

        local contents = function(fzf_cb)
          local handle = io.popen("jj diff --summary 2>&1")
          if not handle then
            return
          end

          for line in handle:lines() do
            -- Only include lines that start with a status letter
            if line:match("^[A-Z]") then
              -- Extract just the filename
              local file = line:match("^%S+%s+(.+)$")
              if file then
                fzf_cb(file)
              end
            end
          end

          handle:close()
          fzf_cb()
        end

        opts = vim.tbl_deep_extend("force", {
          prompt = "jj Status> ",
          preview = "jj diff  --git {1} | delta",
          -- preview = fzf_lua.shell.raw_preview_action_cmd(function(items)
          --   return "jj diff --color=always --git " .. items[1] .. " | delta"
          -- end),
          actions = {
            ["default"] = fzf_lua.actions.file_edit,
            ["ctrl-v"] = fzf_lua.actions.file_vsplit,
            ["ctrl-x"] = fzf_lua.actions.file_split,
            ["ctrl-t"] = fzf_lua.actions.file_tabedit,
          },
          fzf_opts = {
            ["--header"] = "Enter: edit | Ctrl-V/X/T: split",
          },
        }, opts)

        fzf_lua.fzf_exec(contents, opts)
      end
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
          require("fzf-lua-frecency").frecency({
            cwd_only = true,
            fzf_opts = {
              ["--multi"] = true,
              ["--scheme"] = "path",
              ["--no-sort"] = false,
            },
          })
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
        "<leader>j",
        function()
          require("fzf-lua").jj_status({})
        end,
        desc = "jj status",
        mode = { "n" },
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
        "<leader>oh",
        function()
          require("fzf-lua").helptags({})
        end,
        desc = "help tags",
      },
      {
        "<leader>r",
        function()
          require("fzf-lua").live_grep_native({
            fzf_opts = { ["--delimiter"] = ":" },
            keymap = {
              fzf = {
                -- ctrl-g: fzf-lua's live <-> fuzzy toggle (matches the whole line)
                -- ctrl-f: pin results and fuzzy-match the filename only. Works both
                --   straight from live mode and after ctrl-g, since enable-search /
                --   unbind are no-ops once already in fuzzy mode:
                --     unbind(change) stop reloading rg per keystroke (pins results)
                --     enable-search  undo live mode's --disabled (fzf matches now)
                --     change-nth(1)  restrict matching to field 1 (filename)
                --     clear-query    drop the stale rg term so you can type a filename
                ["ctrl-f"] = "unbind(change)+enable-search+change-nth(1)+change-prompt(Filename> )+clear-query",
              },
            },
          })
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
  },
  {
    "fzf-lua-frecency.nvim",
  },
}
