return {
  "osc11.nvim",

  lazy = false,
  priority = 10,

  before = function()
    require("lz.n").trigger_load("modus_operandi")
    require("lz.n").trigger_load("vim-moonfly-colors")
  end,

  after = function()
    local function set_dark()
      require("lz.n").trigger_load("vim-moonfly-colors")
      vim.opt.background = "dark"
      vim.cmd.colorscheme("moonfly")
    end

    local function set_light()
      require("lz.n").trigger_load("modus_operandi")
      vim.opt.background = "light"
      vim.cmd.colorscheme("modus_operandi")
    end

    local function apply_state_from_file()
      local state_home = vim.env.XDG_STATE_HOME
      if state_home == nil or state_home == "" then
        state_home = vim.fn.expand("~/.local/state")
      end
      local state_file = state_home .. "/dark-mode.state"
      if vim.fn.filereadable(state_file) == 1 then
        local line = vim.fn.readfile(state_file, "", 1)[1] or ""
        if line == "true" then
          set_dark()
        else
          set_light()
        end
      else
        set_dark()
      end
    end

    apply_state_from_file()

    require("osc11").setup({
      on_dark = set_dark,
      on_light = set_light,
    })
  end,
}
