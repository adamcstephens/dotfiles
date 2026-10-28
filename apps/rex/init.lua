rex.action({
  name = "vcs_popup",
  title = "Open VCS Popup",
  run = function(ctx)
    local process = assert(rex.block.call("com.superlogical.terminal", "process", {
      block_id = ctx.block_id,
    }))
    local cwd =
      assert(process.foreground and process.foreground.cwd, "Cannot determine the focused terminal's working directory")

    return assert(rex.session.new_layer({
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus = true,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        options = {
          command = { "vcs-tui" },
          cwd = cwd,
        },
      }),
    }))
  end,
})

rex.bind("cmd+g", "vcs_popup")
