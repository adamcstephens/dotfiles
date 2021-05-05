Phoenix.set({
  daemon: true,
  openAtLogin: true,
})

Key.on("f", ["control", "command"], function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: 0, y: 0 })
    window.setSize({ width: screen.width, height: screen.height })
  }
})

Key.on("j", ["control", "command"], function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: 0, y: 0 })
    window.setSize({ width: screen.width / 2, height: screen.height })
  }
})

Key.on("l", ["control", "command"], function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: screen.width / 2, y: 0 })
    window.setSize({ width: screen.width / 2, height: screen.height })
  }
})

Key.on("u", ["control", "command"], function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: 0, y: 0 })
    window.setSize({ width: screen.width / 2, height: screen.height / 2 })
  }
})

Key.on("o", ["control", "command"], function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: screen.width / 2, y: 0 })
    window.setSize({ width: screen.width / 2, height: screen.height / 2 })
  }
})

Key.on("m", ["control", "command"], function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: 0, y: screen.height / 2 })
    window.setSize({ width: screen.width / 2, height: screen.height / 2 })
  }
})

Key.on(".", ["control", "command"], function () {
  const window = Window.focused()
  const screen = Screen.main().flippedVisibleFrame()

  if (window) {
    window.setTopLeft({ x: screen.width / 2, y: screen.height / 2 })
    window.setSize({ width: screen.width / 2, height: screen.height / 2 })
  }
})
