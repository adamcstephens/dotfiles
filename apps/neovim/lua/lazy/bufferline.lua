return {
  "bufferline.nvim",

  lazy = false,

  after = function()
    local bufferline = require("bufferline")
    local function build_config()
      return {
        options = {
          color_icons = false,
          diagnostics = "nvim_lsp",
          diagnostics_update_on_event = true,
          themable = false,
          numbers = "buffer_id",
          separator_style = "slant",
        },
      }
    end

    bufferline.setup(build_config())

    local group = vim.api.nvim_create_augroup("bufferline_refresh", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = function()
        if package.loaded.bufferline then
          require("bufferline.config").update_highlights()
        end
      end,
    })
  end,
}
