return {
  "CopilotChat",

  -- event = "DeferredUIEnter",

  cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatLoad", "CopilotChatToggle" },

  -- lazy = false,

  after = function()
    vim.print("running after")
    require("lz.n").trigger_load("copilot.lua")
    require("CopilotChat").setup({})
  end,
}
