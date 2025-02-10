-- print lsp info
-- lua =vim.lsp.get_active_clients()[5]

local dap = require("dap")
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local capabilities = require("blink.cmp").get_lsp_capabilities()

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

lspconfig.efm.setup({
  capabilities = capabilities,
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

-- elixir
-- if vim.fn.executable("nextls") == 1 then
--   require("elixir").setup({
--     nextls = {
--       enable = true,
--       cmd = "nextls",
--     },
--     credo = { enable = true },
--     elixirls = {
--       enable = true,
--     },
--   })
-- end
if vim.fn.executable("elixir-ls") == 1 then
  lspconfig.elixirls.setup({
    capabilities = capabilities,
    cmd = { "elixir-ls" },
    on_attach = function(client)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  })
end

-- go
lspconfig.golangci_lint_ls.setup({})
if vim.fn.executable("gopls") == 1 then
  lspconfig.gopls.setup({
    capabilities = capabilities,
  })
end
require("dap-go").setup({
  dap_configurations = {
    {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
})

-- fsharp
require("ionide").setup({})
vim.g["fsharp#lsp_auto_setup"] = 0

-- haskell
if vim.fn.executable("haskell-language-server-wrapper") == 1 then
  lspconfig.hls.setup({
    filetypes = { "haskell", "lhaskell", "cabal" },
  })
end

-- html
if vim.fn.executable("superhtml") == 1 then
  require("lspconfig").superhtml.setup({
    capabilities = capabilities,
    filetypes = { "superhtml", "html", "heex" },
  })
end

-- json
if vim.fn.executable("vscode-json-languageserver") == 1 then
  require("lspconfig").jsonls.setup({
    capabilities = capabilities,
    cmd = { "vscode-json-languageserver", "--stdio" },
  })
end

-- lua
lspconfig.lua_ls.setup({
  capabilities = capabilities,
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
require("lspconfig").teal_ls.setup({})

-- nix
if vim.fn.executable("nixd") == 1 then
  lspconfig.nixd.setup({
    capabilities = capabilities,
  })
end
if vim.fn.executable("nil") == 1 then
  lspconfig.nil_ls.setup({
    capabilities = capabilities,
    on_attach = function(client)
      client.server_capabilities.semanticTokensProvider = nil
      client.server_capabilities.documentFormattingProvider = nil
    end,
    settings = {
      ["nil"] = {
        nix = {
          flake = {
            autoArchive = true,
            -- autoEvalInputs = true,
            maxMemoryMB = 8192,
          },
        },
      },
    },
  })
end
-- ignore nix in shebangs
local match_contents = require("vim.filetype.detect").match_contents
require("vim.filetype.detect").match_contents = function(...)
  local result = match_contents(...)
  if result ~= "nix" then -- just don't ever return nix
    return result
  end
end

-- nushell
lspconfig.nushell.setup({
  capabilities = capabilities,
})

-- ocaml
if vim.fn.executable("ocamllsp") == 1 then
  lspconfig.ocamllsp.setup({
    capabilities = capabilities,
    settings = {
      codelens = { enable = true },
    },
  })
end

-- protobuf
-- if vim.fn.executable("buf") == 1 then
--   require("lspconfig").buf_ls.setup({
--     capabilities = capabilities,
--     on_attach = function(client)
--       client.server_capabilities = {
--         semanticTokensProvider = nil,
--       }
--     end,
--   })
-- end

-- python
if vim.fn.executable("pylsp") == 1 then
  require("lspconfig").pylsp.setup({
    capabilities = capabilities,
    settings = {
      pylsp = {
        plugins = {
          mypy = { enabled = true },
        },
      },
    },
  })
end
if vim.fn.executable("pyright") == 1 then
  require("lspconfig").pyright.setup({
    capabilities = capabilities,
  })
end
if vim.fn.executable("ruff") == 1 then
  require("lspconfig").ruff.setup({})
end

-- tofu
if vim.fn.executable("terraform-lsp") == 1 then
  require("lspconfig").terraform_lsp.setup({
    capabilities = capabilities,
  })
end

-- yaml
if vim.fn.executable("yaml-language-server") == 1 then
  require("lspconfig").yamlls.setup({
    capabilities = capabilities,
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
    },
  })
end

-- zig
lspconfig.zls.setup({})
