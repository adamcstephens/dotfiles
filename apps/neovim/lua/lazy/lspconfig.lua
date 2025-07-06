return {
  "nvim-lspconfig",

  lazy = false,

  after = function()
    local efm_languages = {
      fish = {
        require("efmls-configs.linters.fish"),
        require("efmls-configs.formatters.fish_indent"),
      },
      sh = {
        require("efmls-configs.linters.shellcheck"),
        require("efmls-configs.formatters.shfmt"),
      },
    }

    vim.lsp.config("efm", {
      filetypes = vim.tbl_keys(efm_languages),
      settings = {
        rootMarkers = { ".git/" },
        languages = efm_languages,
      },
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
    })
    vim.lsp.enable("efm")

    -- elixir
    vim.lsp.config("elixirls", {
      cmd = { "elixir-ls" },
      on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
      end,
      root_dir = function(bufnr, on_dir)
        local matches = vim.fs.find({ "mix.lock" }, { upward = true, limit = 1 })
        local child_or_root_path, maybe_umbrella_path = unpack(matches)
        local root_dir = vim.fs.dirname(maybe_umbrella_path or child_or_root_path)

        on_dir(root_dir)
      end,
    })
    vim.lsp.enable("elixirls")

    -- go
    vim.lsp.enable("golangci_lint_ls")
    vim.lsp.enable("gopls")

    -- json
    vim.lsp.config("jsonls", {
      cmd = { "vscode-json-languageserver", "--stdio" },
    })
    vim.lsp.enable("jsonls")

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
            },
            useGitIgnore = true,
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("teal_ls")

    -- nix
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
    vim.lsp.config("pylsp", {
      settings = {
        pylsp = {
          plugins = {
            mypy = { enabled = true },
          },
        },
      },
    })
    vim.lsp.enable("pylsp")
    vim.lsp.enable("pyright")
    vim.lsp.enable("ruff")

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
