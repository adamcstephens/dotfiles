local dap = require('dap')
local lspconfig = require('lspconfig')
local configs = require("lspconfig.configs")

local efm_languages = {
  fish = {
    require('efmls-configs.linters.fish'),
    require('efmls-configs.formatters.fish_indent')
  },
  sh = {
    require('efmls-configs.linters.shellcheck'),
    require('efmls-configs.formatters.shfmt'),
  },
}

lspconfig.efm.setup({
  filetypes = vim.tbl_keys(efm_languages),
  settings = {
    rootMarkers = { '.git/' },
    languages = efm_languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
})

-- elixir
-- require("elixir").setup({
--   nextls = {
--     enable = true,
--     cmd = "nextls"
--   },
--   credo = { enable = true },
--   elixirls = {
--     -- disable this and use lspconfig instead
--     enable = false,
--     cmd = "elixir-ls",
--     settings = require("elixir.elixirls").settings {
--       dialyzerEnabled = false,
--       enableTestLenses = false,
--     },
--   }
-- })
-- lspconfig.elixirls.setup({
--   capabilities = require('cmp_nvim_lsp').default_capabilities(),
--   cmd = { "elixir-ls" },
--   on_attach = function(client)
--     client.server_capabilities.semanticTokensProvider = nil
--     vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
--     vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
--     vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
--   end,
--
-- })
lspconfig.lexical.setup({
  cmd = { "lexical" },
})

-- go
lspconfig.gopls.setup({})
require('dap-go').setup({
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
require('ionide').setup({})
vim.g["fsharp#lsp_auto_setup"] = 0

-- haskell
require('lspconfig')['hls'].setup({
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
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
      }
    }
  }
})
require('lspconfig').teal_ls.setup({})

-- nix
lspconfig.nil_ls.setup {
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt", "--quiet" },
      },
      nix = {
        flake = {
          autoArchive = true,
          -- autoEvalInputs = true,
          maxMemoryMB = 8192,
        },
      },
    },
  },
}

-- nushell
lspconfig.nushell.setup({})

-- ocaml
lspconfig.ocamllsp.setup({
  settings = {
    codelens = { enable = true },
  },
})

-- rust
lspconfig.rust_analyzer.setup({
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
  settings = {
    ['rust-analyzer'] = {},
  },
})

-- zig
lspconfig.zls.setup({})
