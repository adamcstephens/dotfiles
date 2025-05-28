return {
  "direnv.nvim",

  lazy = false,

  after = function()
    require("direnv").setup({
      autoload_direnv = true,

      keybindings = {
        allow = "<Leader>da",
        deny = "<Leader>dd",
        reload = "<Leader>dr",
        edit = "<Leader>de",
      },

      statusline = {
        enabled = true,
        icon = "󱚟",
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "DirenvLoaded",
      callback = function()
        vim.cmd("LspStart")
      end,
    })
  end,
}
