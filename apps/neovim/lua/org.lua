require("orgmode").setup({
  org_agenda_files = { "~/Documents/org/**/*" },
  org_default_notes_file = "~/Documents/org/refile.org",
})

require("org-bullets").setup()

-- vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
vim.keymap.set(
  "n",
  "<leader>oh",
  require("telescope").extensions.orgmode.search_headings,
  { desc = "org search headings" }
)
-- vim.keymap.set("n", "<leader>li", require("telescope").extensions.orgmode.insert_link)
