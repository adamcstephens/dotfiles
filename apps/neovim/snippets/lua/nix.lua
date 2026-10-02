local ls = require("luasnip")

local function input_choices()
  local buffer = vim.api.nvim_buf_get_name(0)
  local directory = buffer == "" and vim.fn.getcwd() or vim.fs.dirname(buffer)
  local lockfile = vim.fs.find("flake.lock", { path = directory, upward = true })[1]
  if not lockfile then
    return ls.snippet_node(nil, { ls.insert_node(1, "nixpkgs") })
  end

  local lock = vim.json.decode(table.concat(vim.fn.readfile(lockfile), "\n"))
  local names = vim.tbl_keys(lock.nodes[lock.root].inputs or {})
  table.sort(names)

  local choices = {}
  for _, name in ipairs(names) do
    choices[#choices + 1] = ls.text_node(name)
  end
  if #choices == 0 then
    return ls.snippet_node(nil, { ls.insert_node(1, "nixpkgs") })
  end

  return ls.snippet_node(nil, { ls.choice_node(1, choices) })
end

return {
  ls.snippet({ trig = "input", name = "inputs package" }, {
    ls.text_node("inputs."),
    ls.dynamic_node(1, input_choices, {}),
    ls.text_node("."),
    ls.choice_node(2, {
      ls.text_node("legacyPackages"),
      ls.text_node("packages"),
    }),
    ls.text_node(".${pkgs.stdenv.hostPlatform.system}."),
    ls.insert_node(3, "default"),
    ls.insert_node(0),
  }),
}
