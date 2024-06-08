vim.g.mapleader = " "

vim.keymap.set("n", "<leader>bd", function()
  vim.cmd("bdelete")
end, { desc = "Delete" })

vim.keymap.set("n", "<leader>r", ":source ~/.dotfiles/apps/neovim-vscodium/init.lua<cr>", { desc = "Delete" })

vim.keymap.set("n", "<leader>s", function()
  local function starts_with(str, start)
    return str:sub(1, #start) == start
  end

  vim.cmd("write")
end, { desc = "Save File" })
