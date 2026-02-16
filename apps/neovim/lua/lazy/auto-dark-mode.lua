return {
  "auto-dark-mode.nvim",

  lazy = false,

  after = function()
    require("lz.n").trigger_load("modus_operandi")
    require("lz.n").trigger_load("vim-moonfly-colors")

    if vim.loop.os_uname().sysname ~= "Linux" or os.getenv("XDG_CURRENT_DESKTOP") ~= nil then
      require("auto-dark-mode").setup({
        update_interval = 5000,
        set_dark_mode = function()
          vim.opt.background = "dark"
          vim.cmd.colorscheme("moonfly")
        end,
        set_light_mode = function()
          vim.opt.background = "light"
          vim.cmd.colorscheme("modus_operandi")
        end,
      })
    end
  end,
}
