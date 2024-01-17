$env.config = {
  show_banner: false
  shell_integration: true
  keybindings: [
    {
      name: fuzzy_file
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: {
          send: executehostcommand
          cmd: "commandline -a (
              ls **/*
              | get name
              | input list --fuzzy
                  $'Please choose a (ansi magenta)directory(ansi reset) to (ansi cyan_underline)insert(ansi reset):'
          )"
      }
    }
  ]
  menus: [
    {
      name: completion_menu
      only_buffer_difference: false
      marker: ""
      style: {
        text: foreground
      }
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
    }
  ]
}
