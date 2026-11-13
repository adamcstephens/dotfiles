-- nono can't exec the setuid /usr/bin/login that Rex starts login shells with,
-- so swap each pane that failed that way for a shell started without it.
rex.on("com.superlogical.terminal.child_exited", function(ctx, ev)
  if ev.exit_code ~= 127 then
    return
  end
  local screen = rex.block.call("com.superlogical.terminal", "format", { block_id = ctx.block_id, trim = true })
  if not (screen and screen.content:find("exec /usr/bin/login", 1, true)) then
    return
  end
  assert(rex.session.new_split({
    session_id = ctx.session_id,
    anchor_id = ctx.block_id,
    direction = "horizontal",
    side = "after",
    focus = true,
    layout = rex.layout.block({
      flavor = "com.superlogical.terminal.shell",
      options = { login = false, cwd = rex.args.cwd },
    }),
  }))
  assert(rex.call("block.close", { session_id = ctx.session_id, block_id = ctx.block_id }))
end)
