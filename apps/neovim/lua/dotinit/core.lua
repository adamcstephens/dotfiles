vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true,

  -- virtual_lines = {
  --   -- Only show virtual line diagnostics for the current cursor line
  --   current_line = true,
  -- },

  float = {
    border = "rounded",
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
