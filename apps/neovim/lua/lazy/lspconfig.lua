return {
  "nvim-lspconfig",

  lazy = false,

  after = function()
    -- bash
    vim.lsp.enable("bashls")

    -- elixir
    vim.lsp.config("expert", {
      on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
      end,
    })
    -- vim.lsp.enable("expert")
    vim.lsp.config("dexter", {
      cmd = { "dexter", "lsp" },
      root_markers = { ".dexter.db", ".git", "mix.exs" },
      filetypes = { "elixir", "eelixir", "heex" },
      init_options = {
        followDelegates = true, -- jump through defdelegate to the target function
        -- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
        -- debug = false,        -- verbose logging to stderr (view with :LspLog)
      },
    })
    vim.lsp.enable("dexter")

    -- fish
    vim.lsp.enable("fish_lsp")

    -- go
    vim.lsp.enable("golangci_lint_ls")
    vim.lsp.enable("gopls")

    -- json
    vim.lsp.config("jsonls", {
      cmd = { "vscode-json-languageserver", "--stdio" },
    })
    vim.lsp.enable("jsonls")

    -- julia
    vim.lsp.enable("julials")

    -- lua
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- global gitignore isn't processed
            ignoreDir = {
              ".direnv/",
              ".git/",
              ".jj/",
              "__pycache__/",
              "_build",
              "result",
            },
            useGitIgnore = true,
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("teal_ls")

    -- nix
    vim.lsp.config("nixd", {
      settings = {
        nixd = {
          diagnostic = {
            suppress = { "sema-primop-removed-prefix" },
          },
        },
      },
    })
    vim.lsp.enable("nixd")
    -- ignore nix in shebangs
    local match_contents = require("vim.filetype.detect").match_contents
    require("vim.filetype.detect").match_contents = function(...)
      local result = match_contents(...)
      if result ~= "nix" then -- just don't ever return nix
        return result
      end
    end

    -- ocaml
    vim.lsp.config("ocamllsp", {
      settings = {
        codelens = { enable = true },
      },
    })
    vim.lsp.enable("ocamllsp")

    -- python
    -- vim.lsp.config("pylsp", {
    --   settings = {
    --     pylsp = {
    --       plugins = {
    --         mypy = { enabled = true },
    --       },
    --     },
    --   },
    -- })
    -- vim.lsp.enable("pylsp")
    -- vim.lsp.enable("pyright")
    vim.lsp.enable("ruff")
    vim.lsp.enable("ty")

    -- roc
    vim.lsp.enable("roc_ls")

    -- rust
    vim.lsp.enable("rust_analyzer")

    -- tofu
    vim.lsp.enable("terraformls")

    -- typescript and javascript
    vim.lsp.enable("ts_ls")

    -- yaml
    vim.lsp.config("yamlls", {
      settings = {
        redhat = {
          telemetry = {
            enabled = false,
          },
        },
      },
    })
    vim.lsp.enable("yamlls")

    -- zig
    vim.lsp.enable("zls")

    -- zk
    require("zk").setup({
      picker = "minipick",
    })
    vim.lsp.enable("zk")
  end,
}
