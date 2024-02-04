local autoid = vim.api.nvim_create_augroup("dotgroup", {
  clear = true
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = "show cursorline active",
  callback = function() vim.cmd('set cursorline') end,
  group = autoid
})

vim.api.nvim_create_autocmd('BufLeave', {
  desc = "hide cursorline inactive",
  callback = function() vim.cmd('set nocursorline') end,
  group = autoid
})

vim.api.nvim_create_autocmd('FocusGained', {
  desc = "update ssh auth sock in tmux",
  callback = function()
    if not vim.env.TMUX then return nil end

    local tmuxEnv = vim.gsplit(vim.fn.system('tmux showenv'), '\n')
    local tmuxEnvSSH = vim.iter(tmuxEnv):filter(function(v) return string.match(v, "SSH_AUTH_SOCK") end):totable()
    local tmuxEnvSSHAuthSock = (vim.split(tmuxEnvSSH[1], '='))[2]

    if vim.env.SSH_AUTH_SOCK ~= tmuxEnvSSHAuthSock then
      vim.env.SSH_AUTH_SOCK = tmuxEnvSSHAuthSock
    end
  end,
  group = autoid
})

vim.api.nvim_create_autocmd('FileType', {
  desc = "quit help with q",
  pattern = "help",
  callback = function()
    vim.keymap.set("", "q", function()
      vim.api.nvim_buf_delete(0, {})
    end, { buffer = true, noremap = true, })
  end,
  group = autoid,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  desc = "delete trailing whitespace",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    require('whitespace-nvim').trim()
    vim.fn.setpos(".", save_cursor)
  end
})

vim.api.nvim_create_autocmd({ "FocusLost" }, {
  desc = "disable mouse input",
  callback = function()
    vim.opt.mouse = ""
  end,
  group = autoid
})

vim.api.nvim_create_autocmd({ "FocusGained" }, {
  desc = "re-enable mouse input",
  callback = function()
    vim.defer_fn(function() vim.opt.mouse = "nvi" end, 100)
  end,
  group = autoid
})
