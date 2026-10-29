local bindings = {}
local actions = {}
local foreground
local title
local title_calls
local popup
local forwarded
local context = { block_id = "focused-block", client_id = "test-client", origin = "key" }
local environment = setmetatable({
  rex = {
    action = function(action)
      actions[action.name] = action
    end,
    bind = function(key, action)
      bindings[key] = action
    end,
    client = {
      queue = function(action, args)
        assert(action == "pane.send_key")
        assert(forwarded == nil, "Only one key should be forwarded")
        forwarded = args.key
      end,
    },
    block = {
      call = function(creator, method, args)
        assert(creator == "com.superlogical.terminal")
        assert(args.block_id == context.block_id)
        if method == "process" then
          return { foreground = { name = foreground, cwd = "/test/project" } }
        end
        assert(method == "title")
        title_calls = title_calls + 1
        return { title = title }
      end,
    },
    session = {
      new_layer = function(options)
        assert(popup == nil, "Only one popup should open")
        popup = options
        return { layer_id = "popup-layer" }
      end,
    },
    layout = {
      block = function(options)
        return options
      end,
    },
  },
}, { __index = _G })
setfenv(assert(loadfile(assert(rex.args.config, "Pass config=/absolute/path/to/apps/rex/init.lua"))), environment)()

local cases = {
  { name = "local tuios", process = "tuios", handled = false, titles = 0 },
  { name = "remote tuios", process = "ssh", title = "[kale] tuios ~/p/tracker", handled = false, titles = 1 },
  { name = "local shell", process = "fish", handled = true, titles = 0 },
  { name = "remote shell", process = "ssh", title = "[kale] fish ~/p/tracker", handled = true, titles = 1 },
  { name = "remote editor", process = "ssh", title = "[kale] nvim ~/p/tuios", handled = true, titles = 1 },
  { name = "different program", process = "ssh", title = "[kale] tuios-other ~/p/tracker", handled = true, titles = 1 },
  { name = "stale local title", process = "fish", title = "[kale] tuios ~/p/tracker", handled = true, titles = 0 },
}

local popups = {
  prj_popup = { command = { "env", "REX_CLIENT=test-client", "prj" }, bounds = { 0.3, 0.3, 0.4, 0.4 } },
  vcs_popup = { command = { "vcs-tui" }, bounds = { 0.05, 0.05, 0.9, 0.9 } },
}

local function assert_popup(action)
  local expected = popups[action]
  assert(popup and popup.focus == true, action .. ": popup must take focus")
  assert(popup.layout.flavor == "com.superlogical.terminal.shell")
  assert(popup.layout.options.cwd == "/test/project")
  local command = popup.layout.options.command
  assert(#command == #expected.command)
  for index, value in ipairs(expected.command) do
    assert(command[index] == value, action .. ": incorrect command or client ID")
  end
  for index, value in ipairs(expected.bounds) do
    assert(popup.bounds[index] == value, action .. ": incorrect bounds")
  end
end

for key, action in pairs({ ["cmd+p"] = "prj_popup", ["cmd+g"] = "vcs_popup" }) do
  assert(bindings[key] == action, key .. " must retain named action dispatch and client context")
  for _, case in ipairs(cases) do
    foreground, title = case.process, case.title
    title_calls, popup, forwarded = 0, nil, nil
    context.origin = "key"
    local result = actions[bindings[key]].run(context)
    assert(title_calls == case.titles, key .. ": unexpected title lookup for " .. case.name)
    if case.handled then
      assert(result.layer_id == "popup-layer")
      assert(forwarded == nil, key .. ": unexpected forwarding for " .. case.name)
      assert_popup(action)
    else
      assert(popup == nil, key .. ": unexpected popup for " .. case.name)
      assert(forwarded == key, key .. ": incorrect forwarded key for " .. case.name)
    end
  end
  for _, origin in ipairs({ "palette", "cli" }) do
    foreground, popup, forwarded = "tuios", nil, nil
    context.origin = origin
    assert(actions[action].run(context).layer_id == "popup-layer")
    assert_popup(action)
    assert(forwarded == nil, origin .. ": explicit popup action should not forward a key")
  end
end

assert(bindings["alt+h"] == "pane.focus")
assert(bindings["alt+j"] == "pane.focus")
assert(bindings["alt+k"] == "pane.focus")
assert(bindings["alt+l"] == "pane.focus")
return { passed = #cases * 2 + 4 }
