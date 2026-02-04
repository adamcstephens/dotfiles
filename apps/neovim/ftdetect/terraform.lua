if vim.filetype then
  vim.filetype.add({
    pattern = {
      ["*.tf"] = "terraform",
    },
  })
end
