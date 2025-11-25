-- notifications
return {
  "openingh.nvim",

  cmd = { "OpenInGHFile", "OpenInGHFileLines" },

  before = function()
    vim.g.openingh_copy_to_register = true
  end,

  keys = {
    { "<leader>og", ":OpenInGHFile<CR>", desc = "open git forge file", mode = { "n", "v" } },
    { "<leader>oG", ":OpenInGHFile+<CR>", desc = "yank git forge file", mode = { "n", "v" } },
    { "<leader>ol", ":OpenInGHFileLines<CR>", desc = "open git forge file lines", mode = { "n", "v" } },
    { "<leader>oL", ":OpenInGHFileLines+<CR>", desc = "open git forge file lines", mode = { "n", "v" } },
  },
}
