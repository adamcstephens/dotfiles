local dap = require("dap")
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

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
if vim.fn.executable("nextls") == 1 then
  require("elixir").setup({
    nextls = {
      enable = true,
      cmd = "nextls",
    },
    credo = { enable = true },
    elixirls = {
      enable = false,
    },
  })
end
if vim.fn.executable("elixir-ls") == 1 then
  lspconfig.elixirls.setup({
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(),
    cmd = { "elixir-ls" },
    on_attach = function(client)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  })
end

-- go
lspconfig.golangci_lint_ls.setup({})
if vim.fn.executable("gopls") == 1 then
  lspconfig.gopls.setup({})
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

-- json
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig").jsonls.setup({
  capabilities = capabilities,
  cmd = { "vscode-json-languageserver", "--stdio" },
})

-- lua
lspconfig.lua_ls.setup({
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
lspconfig.nixd.setup({})
-- lspconfig.nil_ls.setup({
--   on_attach = function(client)
--     client.server_capabilities.semanticTokensProvider = nil
--   end,
--   settings = {
--     ["nil"] = {
--       formatting = {
--         command = { "nixfmt", "--quiet" },
--       },
--       nix = {
--         flake = {
--           autoArchive = true,
--           -- autoEvalInputs = true,
--           maxMemoryMB = 8192,
--         },
--       },
--     },
--   },
-- })

-- nushell
lspconfig.nushell.setup({})

-- ocaml
lspconfig.ocamllsp.setup({
  settings = {
    codelens = { enable = true },
  },
})

-- python
if vim.fn.executable("pyright") == 1 then
  require("lspconfig").pyright.setup({})
end

-- tofu
if vim.fn.executable("terraformls") == 1 then
  require("lspconfig").terraformls.setup({})
  vim.filetype.add({
    extension = {
      tf = "terraform",
    },
  })
end

-- yaml
require("lspconfig").yamlls.setup({
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
  },
})

-- zig
lspconfig.zls.setup({})
