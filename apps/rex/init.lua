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

local function pick_project()
  local result = assert(rex.exec({ os.getenv("SHELL"), "-lc", "exec zoxide query --list" }))
  assert(result.ok, result.stderr)
  local items = {}
  for path in result.stdout:gmatch("[^\r\n]+") do
    if #items == 2000 then
      break
    end
    items[#items + 1] = { id = path, icon = "folder" }
  end
  local project, why, detail = rex.ui.pick({
    title = "Open project",
    placeholder = "Filter projects",
    items = items,
  })
  if project == nil and why ~= "cancelled" then
    error(detail or why, 0)
  end
  return project
end

local function project_command(command, project)
  return assert(rex.exec({ os.getenv("SHELL"), "-lc", command }, {
    cwd = project,
    env = { PRJ_PROJECT = project },
  }))
end

rex.action({
  name = "prj_pick",
  title = "Choose Project",
  run = function()
    return { project = pick_project() or "" }
  end,
})

rex.action({
  name = "prj_open",
  title = "Open Project",
  args = { project = "string?", window_label = "string?" },
  run = function(ctx, args)
    if ctx.origin == "key" then
      local process = assert(rex.block.call("com.superlogical.terminal", "process", {
        block_id = ctx.block_id,
      }))
      if tuios_running(ctx, process) then
        return rex.client.queue("pane.send_key", { key = "cmd+p" })
      end
    end
    local project = args.project or pick_project()
    if project == nil then
      return
    end
    local added = project_command('exec zoxide add -- "$PRJ_PROJECT"', project)
    assert(added.ok, added.stderr .. added.stdout)
    local label = args.window_label or project:match("([^/]*)/*$"):gsub("[^a-zA-Z0-9%-]", "")
    local view = assert(rex.session.view({}))
    for _, window in ipairs(view.windows) do
      if window.label == label then
        assert(rex.session.focus_window({ window_id = window.window_id }))
        return rex.client.queue("session.select", { session_id = ctx.session_id, window_id = window.window_id })
      end
    end

    local status = project_command("exec direnv status --json", project)
    if status.ok then
      local found = assert(rex.json.decode(status.stdout)).state.foundRC
      if found ~= nil and found.allowed == 0 then
        local warmed = project_command("exec direnv exec . true", project)
        assert(warmed.ok, warmed.stderr .. warmed.stdout)
      end
    end
    local shell = "com.superlogical.terminal.shell"
    local created = assert(rex.session.new_window({
      window_label = label,
      layout = rex.layout.horizontal(
        0.5,
        rex.layout.block({ flavor = shell, options = { cwd = project } }),
        rex.layout.block({ flavor = shell, options = { cwd = project } })
      ),
    }))
    assert(rex.session.focus_block({ block_id = created.block_ids[1] }))
    return rex.client.queue("session.select", { session_id = ctx.session_id, window_id = created.window_id })
  end,
})

rex.action({
  name = "vcs_popup",
  title = "Open VCS Popup",
  run = function(ctx)
    return open_popup(ctx, "cmd+g", { "vcs-tui" }, { 0.05, 0.05, 0.9, 0.9 })
  end,
})

rex.bind("cmd+alt+p", "prj_open")
rex.bind("cmd+g", "vcs_popup")

rex.bind("cmd+z", "pane.zoom")

rex.bind("alt+h", "pane.focus", { direction = "left" })
rex.bind("alt+j", "pane.focus", { direction = "down" })
rex.bind("alt+k", "pane.focus", { direction = "up" })
rex.bind("alt+l", "pane.focus", { direction = "right" })
