local function tuios_running(ctx, process)
  local name = process.foreground and process.foreground.name
  if name ~= "ssh" then
    return name == "tuios"
  end
  local title = assert(rex.block.call("com.superlogical.terminal", "title", {
    block_id = ctx.block_id,
  })).title
  return title:match("^%[[^%]]+%] tuios%s") ~= nil
end

local function open_popup(ctx, key, command, bounds)
  local process = assert(rex.block.call("com.superlogical.terminal", "process", {
    block_id = ctx.block_id,
  }))
  if ctx.origin == "key" and tuios_running(ctx, process) then
    return rex.client.queue("pane.send_key", { key = key })
  end
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
    return open_popup(ctx, "cmd+p", { "env", "REX_CLIENT=" .. ctx.client_id, "prj" }, { 0.3, 0.3, 0.4, 0.4 })
  end,
})

rex.action({
  name = "vcs_popup",
  title = "Open VCS Popup",
  run = function(ctx)
    return open_popup(ctx, "cmd+g", { "vcs-tui" }, { 0.05, 0.05, 0.9, 0.9 })
  end,
})

rex.bind("cmd+p", "prj_popup")
rex.bind("cmd+g", "vcs_popup")

rex.bind("cmd+z", "pane.zoom")

rex.bind("alt+h", "pane.focus", { direction = "left" })
rex.bind("alt+j", "pane.focus", { direction = "down" })
rex.bind("alt+k", "pane.focus", { direction = "up" })
rex.bind("alt+l", "pane.focus", { direction = "right" })
