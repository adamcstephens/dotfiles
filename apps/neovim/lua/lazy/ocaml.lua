return {
  "ocaml.nvim",

  ft = "ocaml",

  after = function()
    require("ocaml").setup({
      keymaps = {
        jump_next_hole = "<leader>n",
        jump_prev_hole = "<leader>p",
        construct = "<leader>oc",
        jump = "<leader>oj",
        phrase_prev = "<leader>op",
        phrase_next = "<leader>on",
        infer = "<leader>oi",
        switch_ml_mli = "<leader>os",
        type_enclosing = "<leader>ot",
        type_enclosing_grow = "<Up>",
        type_enclosing_shrink = "<Down>",
        type_enclosing_increase = "<Right>",
        type_enclosing_decrease = "<Left>",
      },
    })
  end,
}
