Phoenix.set({
  daemon: true,
  openAtLogin: true,
})

const FOCUS_MODS = ["control", "command"]
const MOVE_MODS = ["control", "command", "shift"]

const WEST = "j"
const EAST = "l"

Key.on("f", MOVE_MODS, function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: 0, y: 0 })
    window.setSize({ width: screen.width, height: screen.height })
  }
})

Key.on(WEST, MOVE_MODS, function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: 0, y: 0 })
    window.setSize({ width: screen.width / 2, height: screen.height })
  }
})

Key.on(EAST, MOVE_MODS, function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: screen.width / 2, y: 0 })
    window.setSize({ width: screen.width / 2, height: screen.height })
  }
})

Key.on("u", MOVE_MODS, function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: 0, y: 0 })
    window.setSize({ width: screen.width / 2, height: screen.height / 2 })
  }
})

Key.on("o", MOVE_MODS, function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: screen.width / 2, y: 0 })
    window.setSize({ width: screen.width / 2, height: screen.height / 2 })
  }
})

Key.on("m", MOVE_MODS, function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: 0, y: screen.height / 2 })
    window.setSize({ width: screen.width / 2, height: screen.height / 2 })
  }
})

Key.on(".", MOVE_MODS, function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: screen.width / 2, y: screen.height / 2 })
    window.setSize({ width: screen.width / 2, height: screen.height / 2 })
  }
})

Key.on(WEST, FOCUS_MODS, function () {
  const window = Window.focused()

  if (window) {
    window.focusClosestNeighbour("west")
  }
})

Key.on(EAST, FOCUS_MODS, function () {
  const window = Window.focused()

  if (window) {
    window.focusClosestNeighbour("east")
  }
})
