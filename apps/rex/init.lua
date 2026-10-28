local function open_popup(ctx, command, bounds)
  local process = assert(rex.block.call("com.superlogical.terminal", "process", {
    block_id = ctx.block_id,
  }))
  local cwd =
    assert(process.foreground and process.foreground.cwd, "Cannot determine the focused terminal's working directory")

  return assert(rex.session.new_layer({
    bounds = bounds,
    focus = true,
    layout = rex.layout.block({
      flavor = "com.superlogical.terminal.shell",
      options = {
        command = command,
        cwd = cwd,
      },
    }),
  }))
end

rex.action({
  name = "prj_popup",
  title = "Open Project Popup",
  run = function(ctx)
    return open_popup(ctx, { "env", "REX_CLIENT=" .. ctx.client_id, "prj" }, { 0.3, 0.3, 0.4, 0.4 })
  end,
})

rex.action({
  name = "vcs_popup",
  title = "Open VCS Popup",
  run = function(ctx)
    return open_popup(ctx, { "vcs-tui" }, { 0.05, 0.05, 0.9, 0.9 })
  end,
})

rex.bind("cmd+p", "prj_popup")
rex.bind("cmd+g", "vcs_popup")
