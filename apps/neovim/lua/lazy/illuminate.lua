return {
  "vim-illuminate",

  event = "DeferredUIEnter",

  after = function()
    -- show matches of hovered word
    require("illuminate").configure({
      providers = {
        "lsp",
        "treesitter",
      },
      case_insensitive_regex = false,
      delay = 100,
      large_file_cutoff = nil,
      large_file_overrides = nil,
      min_count_to_highlight = 1,
      under_cursor = true,
    })
  end,
}
