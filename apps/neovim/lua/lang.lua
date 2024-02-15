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
if os.getenv("LEXICAL_START_PATH") then
  configs.lexical = {
    default_config = {
      filetypes = { "elixir", "eelixir", "heex" },
      cmd = { os.getenv("LEXICAL_START_PATH") },
      root_dir = function(fname)
        return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
      end,
      settings = {},
    },
  }
end
lspconfig.lexical.setup({})

-- go
lspconfig.gopls.setup({})

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
