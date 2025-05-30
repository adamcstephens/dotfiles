return {
  "copilot.lua",

  cmd = "Copilot",

  after = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = false,
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
