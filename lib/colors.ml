open Yojson.Basic.Util

let load_colors =
  let home = Sys.getenv "HOME" in
  Yojson.Basic.from_file (Printf.sprintf "%s/.config/colorscheme.json" home)
  |> member "palette"
