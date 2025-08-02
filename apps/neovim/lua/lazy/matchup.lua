return {
  "vim-matchup",

  after = function()
    require("match-up").setup({
      treesitter = {
        stopline = 500,
      },
    })
  end,
}
