return {
  "toggleterm.nvim",

  cmd = { "ToggleTerm", "TermSelect" },

  after = function()
    require("toggleterm").setup()

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
        vim.opt_local.spell = false
      end,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermOpen" }, {
      pattern = "term://*",
      command = "startinsert",
    })
  end,

  keys = {
    {
      "<leader>t",
      function()
        require("toggleterm").toggle()
      end,
      desc = "Jump Files",
      mode = { "n", "t" },
    },
  },
}
