return {
  "nvim-dap-go",

  ft = "go",

  after = function()
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
  end,
}
