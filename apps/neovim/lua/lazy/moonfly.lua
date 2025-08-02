return {
  "vim-moonfly-colors",

  lazy = false,

  after = function()
    vim.cmd.colorscheme("moonfly")
  end,
}
