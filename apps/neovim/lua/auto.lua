local autoid = vim.api.nvim_create_augroup("dotgroup", {
  clear = true,
})

local osc52_copy = require("vim.ui.clipboard.osc52").copy("+")
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "copy yanks via OSC 52",
  callback = function()
    if vim.v.event.operator == "y" then
      osc52_copy(vim.v.event.regcontents)
    end
  end,
  group = autoid,
})

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "show cursorline active",
  callback = function()
    vim.cmd("set cursorline")
  end,
  group = autoid,
})

vim.api.nvim_create_autocmd("BufLeave", {
  desc = "hide cursorline inactive",
  callback = function()
    vim.cmd("set nocursorline")
  end,
  group = autoid,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "quit help with q",
  pattern = "help",
  callback = function()
    vim.keymap.set("", "q", function()
      vim.api.nvim_buf_delete(0, {})
    end, { buffer = true, noremap = true })
  end,
  group = autoid,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  desc = "delete trailing whitespace",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    require("whitespace-nvim").trim()
    vim.fn.setpos(".", save_cursor)
  end,
})

-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
--   pattern = "*",
--   callback = function()
--     for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
--       if vim.api.nvim_win_get_config(winid).zindex then
--         return
--       end
--     end
--     vim.diagnostic.open_float({
--       scope = "cursor",
--       focusable = false,
--       close_events = {
--         "CursorMoved",
--         "CursorMovedI",
--         "BufHidden",
--         "InsertCharPre",
--         "WinLeave",
--       },
--     })
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "FocusLost" }, {
--   desc = "disable mouse input",
--   callback = function()
--     vim.opt.mouse = ""
--   end,
--   group = autoid
-- })
--
-- vim.api.nvim_create_autocmd({ "FocusGained" }, {
--   desc = "re-enable mouse input",
--   callback = function()
--     vim.defer_fn(function() vim.opt.mouse = "nvi" end, 100)
--   end,
--   group = autoid
-- })
