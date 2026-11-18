local bindings, actions = {}, {}
local foreground, title, title_calls, popup, forwarded, picked
local selected, created, focused_window, focused_block, split
local commands, windows, failure
local selection = [[/test/it's a project; $HOME "quoted" \path]]
local reason, detail
local exec_ok = true
local projects = selection .. "\n/test/other\n"
local status_ok, found_rc, add_ok, warm_ok
local context = { session_id = "test-session", block_id = "focused-block", client_id = "test-client", origin = "key" }

local function api(name)
  if failure == name then
    error("failed " .. name, 0)
  end
end

local environment = setmetatable({
  rex = {
    action = function(action)
      actions[action.name] = action
    end,
    bind = function(key, action)
      bindings[key] = action
    end,
    exec = function(command, options)
      assert(command[1] == os.getenv("SHELL") and command[2] == "-lc" and #command == 3)
      local script = command[3]
      commands[#commands + 1] = script
      api(script)
      if script == "exec zoxide query --list" then
        assert(options == nil)
        return { ok = exec_ok, stdout = projects, stderr = "query failed" }
      end
      assert(options.cwd == selection and options.env.PRJ_PROJECT == selection)
      if script == 'exec zoxide add -- "$PRJ_PROJECT"' then
        return { ok = add_ok, stdout = "", stderr = "add failed" }
      elseif script == "exec direnv status --json" then
        return { ok = status_ok, stdout = "direnv-status-json", stderr = "status failed" }
      elseif script == "exec direnv exec . true" then
        return { ok = warm_ok, stdout = "", stderr = "warmup failed" }
      end
      error("Unexpected subprocess (nested Rex/prj CLI forbidden): " .. script)
    end,
    json = {
      decode = function(value)
        api("decode")
        assert(value == "direnv-status-json")
        return { state = { foundRC = found_rc } }
      end,
    },
    ui = {
      pick = function(options)
        assert(picked == nil)
        picked = options
        return selection, reason, detail
      end,
    },
    client = {
      queue = function(action, args)
        api("queue")
        if action == "pane.send_key" then
          assert(forwarded == nil, "Only one key should be forwarded")
          forwarded = args.key
        else
          assert(action == "session.select" and selected == nil)
          assert(args.session_id == context.session_id)
          selected = args
        end
      end,
    },
    block = {
      call = function(creator, method, args)
        assert(creator == "com.superlogical.terminal" and args.block_id == context.block_id)
        if method == "process" then
          return { foreground = { name = foreground, cwd = "/test/project" } }
        end
        assert(method == "title")
        title_calls = title_calls + 1
        return { title = title }
      end,
    },
    session = {
      view = function(args)
        api("view")
        assert(next(args) == nil)
        return { windows = windows }
      end,
      focus_window = function(args)
        api("focus_window")
        focused_window = args.window_id
        return {}
      end,
      new_window = function(options)
        api("new_window")
        assert(created == nil)
        created = options
        return { window_id = "new-window", block_ids = { "left-block", "right-block" } }
      end,
      focus_block = function(args)
        api("focus_block")
        focused_block = args.block_id
        return {}
      end,
      new_layer = function(options)
        assert(popup == nil, "Only one popup should open")
        popup = options
        return { layer_id = "popup-layer" }
      end,
    },
    layout = {
      block = function(options)
        api("block")
        return options
      end,
      horizontal = function(ratio, left, right)
        api("horizontal")
        assert(ratio == 0.5 and left ~= right)
        split = { left, right }
        return split
      end,
    },
  },
}, { __index = _G })
setfenv(assert(loadfile(assert(rex.args.config, "Pass config=/absolute/path/to/apps/rex/init.lua"))), environment)()

local function reset()
  title_calls, popup, forwarded, picked = 0, nil, nil, nil
  selected, created, focused_window, focused_block, split = nil, nil, nil, nil, nil
  commands, windows, failure = {}, {}, nil
  status_ok, found_rc, add_ok, warm_ok = true, { allowed = 0 }, true, true
end

local function assert_new(label)
  assert(created and created.window_label == label)
  assert(created.layout == split and #split == 2)
  for _, block in ipairs(split) do
    assert(block.flavor == "com.superlogical.terminal.shell")
    assert(block.options.cwd == selection and block.options.command == nil)
  end
  assert(focused_block == "left-block" and focused_window == nil)
  assert(selected.window_id == "new-window")
end

local function assert_popup()
  assert(popup and popup.focus == true)
  assert(popup.layout.flavor == "com.superlogical.terminal.shell")
  assert(popup.layout.options.cwd == "/test/project")
  assert(#popup.layout.options.command == 1 and popup.layout.options.command[1] == "vcs-tui")
  for index, value in ipairs({ 0.05, 0.05, 0.9, 0.9 }) do
    assert(popup.bounds[index] == value)
  end
end

local function assert_picker()
  assert(popup == nil, "Project selection must not open a floating terminal")
  assert(picked.title == "Open project" and picked.placeholder == "Filter projects")
  assert(#picked.items == 2)
  assert(picked.items[1].id == selection and picked.items[1].icon == "folder")
  assert(picked.items[2].id == "/test/other")
  assert_new("itsaprojectHOMEquotedpath")
end

local cases = {
  { name = "local tuios", process = "tuios", handled = false, titles = 0 },
  { name = "remote tuios", process = "ssh", title = "[kale] tuios ~/p/tracker", handled = false, titles = 1 },
  { name = "local shell", process = "fish", handled = true, titles = 0 },
  { name = "remote shell", process = "ssh", title = "[kale] fish ~/p/tracker", handled = true, titles = 1 },
  { name = "remote editor", process = "ssh", title = "[kale] nvim ~/p/tuios", handled = true, titles = 1 },
  { name = "different program", process = "ssh", title = "[kale] tuios-other ~/p/tracker", handled = true, titles = 1 },
  { name = "stale local title", process = "fish", title = "[kale] tuios ~/p/tracker", handled = true, titles = 0 },
}
for key, action in pairs({ ["cmd+alt+p"] = "prj_open", ["cmd+g"] = "vcs_popup" }) do
  local forwarded_key = action == "prj_open" and "cmd+p" or key
  assert(bindings[key] == action, key .. " must retain named action dispatch and client context")
  for _, case in ipairs(cases) do
    foreground, title = case.process, case.title
    reset()
    context.origin = "key"
    local result = actions[action].run(context, {})
    assert(title_calls == case.titles, key .. ": unexpected title lookup for " .. case.name)
    if case.handled then
      assert(forwarded == nil)
      if action == "prj_open" then
        assert_picker()
      else
        assert(result.layer_id == "popup-layer")
        assert_popup()
      end
    else
      assert(popup == nil and picked == nil and created == nil and #commands == 0)
      assert(forwarded == forwarded_key)
    end
  end
  for _, origin in ipairs({ "palette", "cli" }) do
    foreground = "tuios"
    reset()
    context.origin = origin
    actions[action].run(context, {})
    if action == "prj_open" then
      assert_picker()
    else
      assert_popup()
    end
    assert(forwarded == nil, origin .. ": explicit action should not forward a key")
  end
end

reset()
assert(actions.prj_pick.run(context, {}).project == selection)
assert(picked ~= nil and created == nil and popup == nil and #commands == 1)

reset()
actions.prj_open.run(context, { project = selection, window_label = "Exact custom label!" })
assert(picked == nil)
assert_new("Exact custom label!")
assert(#commands == 3 and commands[1] == 'exec zoxide add -- "$PRJ_PROJECT"')
assert(commands[2] == "exec direnv status --json" and commands[3] == "exec direnv exec . true")

reset()
windows = {
  { label = "other", window_id = "other-window" },
  { label = "itsaprojectHOMEquotedpath", window_id = "existing-window" },
}
actions.prj_open.run(context, { project = selection })
assert(focused_window == "existing-window" and selected.window_id == "existing-window")
assert(created == nil and split == nil and focused_block == nil and #commands == 1)

for _, state in ipairs({ "allowed", "disallowed", "absent", "status failure" }) do
  reset()
  if state == "disallowed" then
    found_rc = { allowed = 1 }
  elseif state == "absent" then
    found_rc = nil
  elseif state == "status failure" then
    status_ok = false
    failure = "decode"
  end
  actions.prj_open.run(context, { project = selection })
  assert_new("itsaprojectHOMEquotedpath")
  assert(#commands == (state == "allowed" and 3 or 2), state)
end

local original_selection = selection
selection = "/test/parent.name/project_name-42///"
reset()
actions.prj_open.run(context, { project = selection })
assert(picked == nil)
assert_new("projectname-42")
selection = original_selection

for _, name in ipairs({
  "view",
  "new_window",
  "focus_block",
  "queue",
  "decode",
  "block",
  "horizontal",
  'exec zoxide add -- "$PRJ_PROJECT"',
  "exec direnv status --json",
  "exec direnv exec . true",
  "focus_window",
}) do
  reset()
  failure = name
  if name == "focus_window" then
    windows = { { label = "existing", window_id = "existing-window" } }
  end
  local ok, err = pcall(actions.prj_open.run, context, { project = selection, window_label = "existing" })
  assert(not ok and err == "failed " .. name, name)
end
for _, name in ipairs({ "add", "warmup" }) do
  reset()
  if name == "add" then
    add_ok = false
  else
    warm_ok = false
  end
  local ok, err = pcall(actions.prj_open.run, context, { project = selection })
  assert(not ok and tostring(err):find(name .. " failed", 1, true))
  assert(created == nil and selected == nil)
end

selection, reason = nil, "cancelled"
reset()
actions.prj_open.run(context, {})
assert(picked ~= nil and created == nil and #commands == 1)
reset()
assert(actions.prj_pick.run(context, {}).project == "")
assert(created == nil)
for _, why in ipairs({ "timeout", "no_client", "unsupported", "busy", "failed" }) do
  reason = why
  reset()
  local ok, err = pcall(actions.prj_open.run, context, {})
  assert(not ok and err == why)
  assert(created == nil and #commands == 1)
end
reason, detail = "failed", "Picker service failed"
reset()
local ok, err = pcall(actions.prj_pick.run, context, {})
assert(not ok and err == detail)
detail = nil

exec_ok = false
reset()
ok, err = pcall(actions.prj_pick.run, context, {})
assert(not ok and tostring(err):find("query failed", 1, true))
assert(picked == nil and created == nil)
exec_ok = true
projects, reason = "", "cancelled"
reset()
actions.prj_pick.run(context, {})
assert(#picked.items == 0)
projects = ""
for index = 1, 2001 do
  projects = projects .. "/test/" .. index .. "\n"
end
reset()
actions.prj_pick.run(context, {})
assert(#picked.items == 2000 and picked.items[2000].id == "/test/2000")

assert(actions.prj_popup == nil)
for _, key in ipairs({ "alt+h", "alt+j", "alt+k", "alt+l" }) do
  assert(bindings[key] == "pane.focus")
end
return { passed = true }
