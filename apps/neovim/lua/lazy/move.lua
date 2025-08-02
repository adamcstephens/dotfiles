return {
  "move.nvim",

  lazy = false,

  keys = {
    { "<A-Down>", ":MoveLine(1)<CR>", mode = "n" },
    { "<A-Up>", ":MoveLine(-1)<CR>", mode = "n" },
    { "<A-Down>", ":MoveBlock(1)<CR>", mode = "v" },
    { "<A-Up>", ":MoveBlock(-1)<CR>", mode = "v" },
  },

  after = function()
    require("move").setup({
      block = {
        enable = true,
        indent = true,
      },
      char = {
        enable = true,
      },
    })
  end,
}
