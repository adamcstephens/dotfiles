-- use experiemental lua loader
vim.loader.enable()

vim.g.mapleader = ","

-- includes
--
require("auto")
require("dotinit.core")

-- packages
--

require("nvim-web-devicons").setup({})
require("remember").setup({})

require("which-key").setup({})
require("whitespace-nvim").setup({})

-- vim settings
--
-- force osc 52 to bypass checks since we use a supported terminal
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  -- paste = {
  --   ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
  --   ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  -- },
}

-- disable end of line diagnostic message
vim.diagnostic.config({ virtual_text = false })

vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 750 -- swapfile and cursorhold
vim.opt.whichwrap = "<,>,[,]"

-- folding
vim.o.fillchars = [[eob: ,fold: ,foldopen:-,foldsep: ,foldclose:⏵]]
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
require("ufo").setup({
  provider_selector = function()
    return { "treesitter", "indent" }
  end,
})
local statuscol = require("statuscol.builtin")
require("statuscol").setup({
  segments = {
    { text = { "%s" }, click = "v:lua.ScSa" },
    { text = { statuscol.lnumfunc }, click = "v:lua.ScLa" },
    {
      text = { " ", statuscol.foldfunc, " " },
      condition = { statuscol.not_empty, true, statuscol.not_empty },
      click = "v:lua.ScFa",
    },
  },
})

-- mappings
--
-- map ctrl-a/e to begin/end of line
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")
vim.keymap.set("n", "<C-e>", "$")
vim.keymap.set("n", "<C-a>", "0")

vim.keymap.set("n", "<leader>bd", function()
  vim.cmd("bdelete")
end, { desc = "Delete" })

vim.keymap.set("n", "<leader>li", vim.lsp.buf.hover, { desc = "Show hover" })
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set("n", "<leader>s", function()
  local function starts_with(str, start)
    return str:sub(1, #start) == start
  end

  if starts_with(vim.api.nvim_buf_get_name(0), "oil:///") then
    vim.cmd("write")
  else
    vim.cmd("write ++p")
  end
end, { desc = "Save File" })
vim.keymap.set("n", "<leader>S", function()
  vim.cmd("noautocmd write ++p")
end, { desc = "Save File (No autocmd)" })

-- diagnostics
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })
