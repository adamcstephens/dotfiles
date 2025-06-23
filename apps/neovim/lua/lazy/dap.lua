return {
  "nvim-dap",

  keys = {
    { "<leader>db", require("dap").toggle_breakpoint, desc = "dap toggle breakpoint" },
    {
      "<leader>dc",
      function()
        -- (Re-)reads launch.json if present
        if vim.fn.filereadable(".vscode/launch.json") then
          require("dap.ext.vscode").load_launchjs(nil, { lldb = { "rust" } })
        end
        require("dap").continue()
      end,
      desc = "dap continue (start)",
    },
    { "<leader>dr", require("dap").repl.open, desc = "dap repl" },
  },
}
