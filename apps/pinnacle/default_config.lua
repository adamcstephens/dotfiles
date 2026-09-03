local Pinnacle = require("pinnacle")
local Input = require("pinnacle.input")
local Libinput = require("pinnacle.input.libinput")
local Process = require("pinnacle.process")
local Output = require("pinnacle.output")
local Tag = require("pinnacle.tag")
local Window = require("pinnacle.window")
local Layout = require("pinnacle.layout")
local Util = require("pinnacle.util")
-- `Snowcap` will be false when the Snowcap API isn't installed or Snowcap isn't running
local Snowcap = require("pinnacle.snowcap")

Pinnacle.setup(function()
  -- load our path in
  local home = assert(os.getenv("HOME"))
  local profile = home .. "/.local/state/hjem/standalone/current-profile"
  local path = assert(os.getenv("PATH"), "PATH is not set")
  Process.set_env("PATH", profile .. "/bin:" .. home .. "/.dotfiles/bin:" .. path)

  local key = Input.key

  ---@type pinnacle.input.Mod
  local mod_key = "super"
  -- Change the mod key to "alt" when running as a nested window
  if Pinnacle.backend() == "window" then
    mod_key = "alt"
  end

  local terminal = "terminal"

  -- cursor
  Input.set_xcursor_theme("Bibata-Original-Ice")
  Input.set_xcursor_size(28)

  --------------------
  -- Mousebinds     --
  --------------------

  -- mod_key + left click drag = move a window
  Input.mousebind({ mod_key }, "btn_left", function()
    Window.begin_move("btn_left")
  end, {
    group = "Mouse",
    description = "Start an interactive window move",
  })

  -- mod_key + right click drag = resize a window
  Input.mousebind({ mod_key }, "btn_right", function()
    Window.begin_resize("btn_right")
  end, { group = "Mouse", description = "Start an interactive window resize" })

  --------------------
  -- Keybinds       --
  --------------------

  -- mod_key + s shows the keybind overlay
  if Snowcap then
    Input.keybind({ mod_key }, "s", function()
      Snowcap.integration.bind_overlay():show()
    end, {
      group = "Compositor",
      description = "Show the keybind overlay",
    })
  end

  if Snowcap then
    -- mod_key + shift + q = Quit Prompt
    Input.keybind({
      mods = { mod_key, "shift", "control" },
      key = "x",
      on_press = function()
        Snowcap.integration.quit_prompt():show()
      end,
      group = "Compositor",
      description = "Show the quit prompt",
    })
  else
    -- mod_key + shift + q = Quit Pinnacle
    Input.keybind({
      mods = { mod_key, "shift", "control" },
      key = "x",
      quit = true,
      group = "Compositor",
      description = "Quit Pinnacle",
    })
  end

  -- mod_key + ctrl + r = Reload config
  Input.keybind({
    mods = { mod_key, "ctrl" },
    key = "r",
    reload_config = true,
    group = "Compositor",
    description = "Reload the config",
  })

  -- mod_key + shift + c = Close window
  Input.keybind({ mod_key, "shift" }, "c", function()
    local focused = Window.get_focused()
    if focused then
      focused:close()
    end
  end, {
    group = "Window",
    description = "Close the focused window",
  })

  -- mod_key + shift + t = Spawn `terminal`
  Input.keybind({
    mods = { mod_key, "shift" },
    key = "t",
    on_press = function()
      Process.spawn(terminal)
    end,
    group = "Process",
    description = "Spawn a terminal",
  })
  -- mod_key + Return = Spawn `terminal`
  Input.keybind({ mod_key }, key.Return, function()
    Process.spawn(terminal)
  end, {
    group = "Process",
    description = "Spawn a terminal",
  })

  -- mod_key + f = Toggle fullscreen
  Input.keybind({ mod_key, "shift" }, "f", function()
    local focused = Window.get_focused()
    if focused then
      focused:toggle_fullscreen()
      focused:raise()
    end
  end, {
    group = "Window",
    description = "Toggle fullscreen on the focused window",
  })

  -- mod_key + m = Toggle maximized
  Input.keybind({ mod_key }, "m", function()
    local focused = Window.get_focused()
    if focused then
      focused:toggle_maximized()
      focused:raise()
    end
  end, {
    group = "Window",
    description = "Toggle maximized on the focused window",
  })

  -- dotfiles keybinds ---------------------------

  Input.keybind({ mod_key }, "d", function()
    Process.spawn("noctalia", "msg", "panel-toggle", "launcher")
  end, {
    group = "Process",
    description = "Toggle the launcher",
  })

  -- Media keybinds ----------------------------------------------------

  Input.keybind({
    mods = {},
    key = key.XF86AudioRaiseVolume,
    on_press = function()
      Process.spawn("wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "0.02+", "-l", "1.0")
    end,
    allow_when_locked = true,
    group = "Media",
    description = "Increase volume by 2%",
  })

  Input.keybind({
    mods = {},
    key = key.XF86AudioLowerVolume,
    on_press = function()
      Process.spawn("wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "0.02-", "-l", "1.0")
    end,
    allow_when_locked = true,
    group = "Media",
    description = "Decrease volume by 2%",
  })

  Input.keybind({
    mods = {},
    key = key.XF86AudioMute,
    on_press = function()
      Process.spawn("wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle")
    end,
    allow_when_locked = true,
    group = "Media",
    description = "Toggle mute",
  })

  Input.keybind({
    mods = {},
    key = key.XF86AudioMicMute,
    on_press = function()
      Process.spawn("wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle")
    end,
    allow_when_locked = true,
    group = "Media",
    description = "Toggle mic mute",
  })

  Input.keybind({
    mods = {},
    key = key.XF86AudioPlay,
    on_press = function()
      Process.spawn("playerctl", "play-pause")
    end,
    allow_when_locked = true,
    group = "Media",
    description = "Play/pause media",
  })

  Input.keybind({
    mods = {},
    key = key.XF86AudioStop,
    on_press = function()
      Process.spawn("playerctl", "stop")
    end,
    allow_when_locked = true,
    group = "Media",
    description = "Stop media",
  })

  Input.keybind({
    mods = {},
    key = key.XF86AudioNext,
    on_press = function()
      Process.spawn("playerctl", "next")
    end,
    allow_when_locked = true,
    group = "Media",
    description = "Go to next media",
  })

  Input.keybind({
    mods = {},
    key = key.XF86AudioPrev,
    on_press = function()
      Process.spawn("playerctl", "previous")
    end,
    allow_when_locked = true,
    group = "Media",
    description = "Go to previous media",
  })

  -- Display brightness keybinds ----------------------------------

  Input.keybind({
    mods = {},
    key = key.XF86MonBrightnessUp,
    on_press = function()
      Process.spawn("brightnessctl", "--class=backlight", "set", "+10%")
    end,
    allow_when_locked = true,
    group = "Display",
    description = "Increase display brightness by 10%",
  })

  Input.keybind({
    mods = {},
    key = key.XF86MonBrightnessDown,
    on_press = function()
      Process.spawn("brightnessctl", "--class=backlight", "set", "10%-")
    end,
    allow_when_locked = true,
    group = "Display",
    description = "Decrease display brightness by 10%",
  })

  --------------------
  -- Layouts        --
  --------------------

  -- Pinnacle supports a tree-based layout system built on layout nodes.
  --
  -- To determine the tree used to layout windows, Pinnacle requests your config for a tree data structure
  -- with nodes containing gaps, directions, etc. There are a few provided utilities for creating
  -- a layout, known as layout generators.
  --
  -- ### Layout generators ###
  -- A layout generator is a table that holds some state as well as
  -- the `layout` function, which takes in a window count and computes
  -- a tree of layout nodes that determines how windows are laid out.
  --
  -- There are currently seven built-in layout generators, one of which delegates to other
  -- generators as shown below.

  -- Create a cycling layout generator. This provides methods to cycle
  -- between the provided layout generators below.
  local layout_cycler = Layout.builtin.cycle({
    -- `Layout.builtin` contains functions that create various layout generators.
    -- Each of these has settings that can be overridden by passing in a table with
    -- overriding options.
    Layout.builtin.master_stack(),
    Layout.builtin.master_stack({ master_side = "right" }),
    Layout.builtin.master_stack({ master_side = "top" }),
    Layout.builtin.master_stack({ master_side = "bottom" }),
    Layout.builtin.dwindle(),
    Layout.builtin.spiral(),
    Layout.builtin.corner(),
    Layout.builtin.corner({ corner_loc = "top_right" }),
    Layout.builtin.corner({ corner_loc = "bottom_left" }),
    Layout.builtin.corner({ corner_loc = "bottom_right" }),
    Layout.builtin.fair(),
    Layout.builtin.fair({ axis = "horizontal" }),
    Layout.builtin.floating(),
  })

  -- Use the cycling layout generator to manage layout requests.
  -- This returns an object that allows you to request layouts manually.
  local layout_requester = Layout.manage(function(args)
    local first_tag = args.tags[1]
    if not first_tag then
      ---@type pinnacle.layout.LayoutResponse
      return {
        root_node = {},
        tree_id = 0,
      }
    end
    layout_cycler.current_tag = first_tag
    local root_node = layout_cycler:layout(args.window_count)
    local tree_id = layout_cycler:current_tree_id()

    ---@type pinnacle.layout.LayoutResponse
    return {
      root_node = root_node,
      tree_id = tree_id,
    }
  end)

  -- mod_key + space = Cycle forward one layout on the focused output
  --
  -- Yes, this is a bit verbose for my liking.
  -- You need to cycle the layout on the first active tag
  -- because that is the one that decides which layout is used.
  Input.keybind({ mod_key }, key.space, function()
    local focused_op = Output.get_focused()
    if focused_op then
      local tags = focused_op:tags() or {}
      local tag = nil

      ---@type (fun(): (boolean|nil))[]
      local tag_actives = {}
      for i, t in ipairs(tags) do
        tag_actives[i] = function()
          return t:active()
        end
      end

      -- We are batching API calls here for better performance
      tag_actives = Util.batch(tag_actives)

      for i, active in ipairs(tag_actives) do
        if active then
          tag = tags[i]
          break
        end
      end

      if tag then
        layout_cycler:cycle_layout_forward(tag)
        layout_requester:request_layout(focused_op)
      end
    end
  end, {
    group = "Layout",
    description = "Cycle the layout forward on the first active tag",
  })

  -- mod_key + shift + space = Cycle backward one layout on the focused output
  Input.keybind({ mod_key, "shift" }, key.space, function()
    local focused_op = Output.get_focused()
    if focused_op then
      local tags = focused_op:tags() or {}
      local tag = nil

      ---@type (fun(): boolean)[]
      local tag_actives = {}
      for i, t in ipairs(tags) do
        tag_actives[i] = function()
          return t:active()
        end
      end

      tag_actives = Util.batch(tag_actives)

      for i, active in ipairs(tag_actives) do
        if active then
          tag = tags[i]
          break
        end
      end

      if tag then
        layout_cycler:cycle_layout_backward(tag)
        layout_requester:request_layout(focused_op)
      end
    end
  end, {
    group = "Layout",
    description = "Cycle the layout backward on the first active tag",
  })

  ----------------------
  -- Tags and Outputs --
  ----------------------

  -- Last tag switched away from, keyed by output name
  local prev_tag = {}

  -- switch to tag or if current tag, switch to prev
  local function switch_to_tag(tag_name)
    local output = Output.get_focused()
    if not output then
      return
    end

    local tags = output:tags() or {}

    ---@type (fun(): { active: boolean, name: string? })[]
    local requests = {}
    for i, t in ipairs(tags) do
      requests[i] = function()
        return { active = t:active(), name = t:name() }
      end
    end
    requests = Util.batch(requests)

    local current = nil
    for i = 1, #tags do
      local res = requests[i]
      if res and res.active then
        current = res.name
        break
      end
    end

    local target = tag_name
    if target == nil or target == current then
      target = prev_tag[output.name]
    end
    if not target then
      return
    end

    local tag = Tag.get(target, output)
    if tag then
      prev_tag[output.name] = current
      tag:switch_to()
    end
  end

  Input.keybind({ mod_key }, key.grave, function()
    switch_to_tag(nil)
  end, { group = "Tag", description = "Switch to the previous tag" })

  local tag_names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

  Output.for_each_output(function(output)
    local tags = Tag.add(output, tag_names)
    tags[1]:set_active(true)
  end)

  -- Outputs that connect later (e.g. docking) start with no tags at all
  Output.connect_signal({
    connect = function(output)
      if #(output:tags() or {}) == 0 then
        local tags = Tag.add(output, tag_names)
        tags[1]:set_active(true)
      end
    end,
  })

  -- Tag keybinds
  for _, tag_name in ipairs(tag_names) do
    -- mod_key + 1-9 = Switch to tags 1-9
    Input.keybind({ mod_key }, tag_name, function()
      switch_to_tag(tag_name)
    end, {
      group = "Tag",
      description = "Switch to tag " .. tag_name,
    })

    -- mod_key + ctrl + 1-9 = Toggle tags 1-9
    Input.keybind({ mod_key, "ctrl" }, tag_name, function()
      Tag.get(tag_name):toggle_active()
    end, {
      group = "Tag",
      description = "Toggle tag " .. tag_name,
    })

    -- mod_key + shift + 1-9 = Move window to tags 1-9
    Input.keybind({ mod_key, "shift" }, tag_name, function()
      local focused = Window.get_focused()
      if focused then
        focused:move_to_tag(Tag.get(tag_name) --[[@as pinnacle.tag.TagHandle]])
      end
    end, {
      group = "Tag",
      description = "Move the focused window to tag " .. tag_name,
    })

    -- mod_key + ctrl + shift + 1-9 = Toggle tags 1-9 on window
    Input.keybind({ mod_key, "ctrl", "shift" }, tag_name, function()
      local focused = Window.get_focused()
      if focused then
        focused:toggle_tag(Tag.get(tag_name) --[[@as pinnacle.tag.TagHandle]])
      end
    end, {
      group = "Tag",
      description = "Toggle tag " .. tag_name .. " on the focused window",
    })
  end

  -- Move the focused window to the next/previous output, keeping its tag
  local function move_focused_to_output(direction)
    local focused = Window.get_focused()
    local current_output = Output.get_focused()
    if not focused or not current_output then
      return
    end

    local outputs = Output.get_all_enabled()
    if #outputs < 2 then
      return
    end

    local current_index = nil
    for i, o in ipairs(outputs) do
      if o.name == current_output.name then
        current_index = i
        break
      end
    end
    if not current_index then
      return
    end

    local target_index = ((current_index - 1 + direction) % #outputs) + 1
    local target_output = outputs[target_index]

    for _, tag in ipairs(focused:tags() or {}) do
      local target_tag = Tag.get(tag:name(), target_output)
      if target_tag then
        focused:set_tag(tag, false)
        focused:set_tag(target_tag, true)
      end
    end
  end

  Input.keybind({ mod_key, "shift" }, key.period, function()
    move_focused_to_output(1)
  end, {
    group = "Output",
    description = "Move the focused window to the next output",
  })

  Input.keybind({ mod_key, "shift" }, key.comma, function()
    move_focused_to_output(-1)
  end, {
    group = "Output",
    description = "Move the focused window to the previous output",
  })

  -- Move every window currently on `from_output` (or all outputs, if nil) to
  -- `to_output`, keeping tag numbers
  local function relocate_windows(to_output, from_output)
    for _, win in ipairs(Window.get_all()) do
      for _, tag in ipairs(win:tags() or {}) do
        if not from_output or tag:output().name == from_output.name then
          local target_tag = Tag.get(tag:name(), to_output)
          if target_tag then
            win:set_tag(tag, false)
            win:set_tag(target_tag, true)
          end
        end
      end
    end
  end

  -- Move every window to the currently focused output, keeping tag numbers
  Input.keybind({ mod_key, "shift", "ctrl" }, "r", function()
    local output = Output.get_focused()
    if output then
      relocate_windows(output)
    end
  end, {
    group = "Output",
    description = "Relocate all windows to the focused output",
  })

  -- Pinnacle fires the connect/disconnect signals for enable/disable too
  -- (there's no dedicated signal for that yet), which covers shikane
  -- toggling an output's `enable` on/off. Relocate windows stranded on a
  -- disabling output to whatever's left enabled.
  Output.connect_signal({
    disconnect = function(output)
      local fallback = Output.get_all_enabled()[1] or Output.get_focused()
      if fallback and fallback.name ~= output.name then
        relocate_windows(fallback, output)
      end
    end,
  })

  -----------------------
  -- Libinput settings --
  -----------------------

  Libinput.for_each_device(function(device)
    -- Enable natural scroll for touchpads
    if device:device_type() == "touchpad" then
      device:set_natural_scroll(true)
    end
  end)

  -----------------------
  -- Keyboard settings --
  -----------------------
  Input.set_repeat_rate(60, 300)

  -----------------------
  -- Other stuff       --
  -----------------------

  -- Enable focus borders
  if Snowcap then
    local Color = require("snowcap.widget").color

    local function decorate(window)
      local border = Snowcap.integration.focus_border(window)
      border.thickness = 1
      border.focused_color = Color.from_rgba(0.55, 0.55, 0.6)
      border.unfocused_color = Color.from_rgba(0.12, 0.12, 0.14)
      border:decorate()
    end

    -- Add borders to already existing windows
    for _, win in ipairs(Window.get_all()) do
      decorate(win)
    end

    -- Add borders to new windows
    Window.add_window_rule(function(window)
      window:set_decoration_mode("server_side")
      decorate(window)
    end)
  end

  -- A swap shifts the layout under a stationary pointer, which emits
  -- pointer_enter for the displaced window; that must not steal focus.
  local swap_displaced = nil

  -- Enable sloppy focus
  Window.connect_signal({
    pointer_enter = function(window)
      local displaced = swap_displaced
      swap_displaced = nil
      if window.id ~= displaced then
        window:set_focused(true)
      end
    end,
  })

  -- Focus outputs when the pointer enters them
  Output.connect_signal({
    pointer_enter = function(output)
      output:focus()
    end,
  })

  --
  -- Window navigation
  --
  -- Windows on the focused output's active tags, in layout stack order
  local function view_stack()
    local output = Output.get_focused()
    if not output then
      return {}
    end

    local tags = output:tags() or {}

    ---@type (fun(): boolean)[]
    local requests = {}
    for i, t in ipairs(tags) do
      requests[i] = function()
        return t:active()
      end
    end
    requests = Util.batch(requests)

    local active_ids = {}
    for i = 1, #tags do
      if requests[i] then
        active_ids[tags[i].id] = true
      end
    end

    local wins = Window.get_all()

    ---@type (fun(): pinnacle.tag.TagHandle[])[]
    local tag_requests = {}
    for i, w in ipairs(wins) do
      tag_requests[i] = function()
        return w:tags()
      end
    end
    tag_requests = Util.batch(tag_requests)

    local stack = {}
    for i = 1, #wins do
      for _, t in ipairs(tag_requests[i] or {}) do
        if active_ids[t.id] then
          table.insert(stack, wins[i])
          break
        end
      end
    end

    return stack
  end

  local function stack_neighbor(offset)
    local stack = view_stack()
    if #stack < 2 then
      return nil, nil
    end

    local focused = Window.get_focused()
    local idx = 1
    if focused then
      for i, w in ipairs(stack) do
        if w.id == focused.id then
          idx = i
          break
        end
      end
    end

    return stack[(idx - 1 + offset) % #stack + 1], focused
  end

  local function swap_windows(focused, target)
    swap_displaced = target.id
    focused:swap(target)
  end

  for key_name, offset in pairs({ j = 1, k = -1 }) do
    -- focus-view next/previous
    Input.keybind({ mod_key }, key_name, function()
      local target = stack_neighbor(offset)
      if target then
        target:set_focused(true)
        target:raise()
      end
    end, { group = "Window", description = "Focus the " .. (offset == 1 and "next" or "previous") .. " window" })

    -- swap next/previous
    Input.keybind({ mod_key, "shift" }, key_name, function()
      local target, focused = stack_neighbor(offset)
      if target and focused then
        swap_windows(focused, target)
      end
    end, { group = "Window", description = "Swap with the " .. (offset == 1 and "next" or "previous") .. " window" })
  end

  -- mod_key + a = Move the focused window into the master area
  Input.keybind({ mod_key }, "a", function()
    local focused = Window.get_focused()
    local master = view_stack()[1]
    if focused and master and master.id ~= focused.id then
      swap_windows(focused, master)
    end
  end, {
    group = "Window",
    description = "Move the focused window to the master area",
  })

  -- resize
  Input.keybind({
    mods = { mod_key, "shift" },
    key = "l",
    on_press = function()
      Window.get_focused():resize_tile({ right = 20 })
    end,
    group = "Window",
    description = "Increase window to the right",
  })

  Input.keybind({
    mods = { mod_key, "shift" },
    key = key.Right,
    on_press = function()
      Window.get_focused():resize_tile({ right = 20 })
    end,
    group = "Window",
    description = "Increase window to the right",
  })

  Input.keybind({
    mods = { mod_key, "shift" },
    key = "h",
    on_press = function()
      Window.get_focused():resize_tile({ left = 20 })
    end,
    group = "Window",
    description = "Increase window to the left",
  })

  Input.keybind({
    mods = { mod_key, "shift" },
    key = key.Left,
    on_press = function()
      Window.get_focused():resize_tile({ right = -20 })
    end,
    group = "Window",
    description = "Decrease window from the right",
  })
end)
