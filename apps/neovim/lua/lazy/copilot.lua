return {
  "copilot.lua",

  cmd = "Copilot",

  after = function()
    require("copilot").setup({
      suggestion = {
        enabled = false,
        auto_trigger = false,
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      },
    })
  end,
}
