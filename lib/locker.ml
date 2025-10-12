open Colors
open Yojson.Basic.Util

type locker = Gtklock | Waylock

let waylock ~palette =
  let init_color = palette |> member "base04" |> to_string in
  let input_color = palette |> member "base0A" |> to_string in
  let fail_color = palette |> member "base08" |> to_string in
  Printf.sprintf
    "waylock -fork-on-lock -init-color 0x%s -input-color 0x%s -fail-color 0x%s"
    init_color input_color fail_color

let get_locker lock =
  match lock with
  | Gtklock -> "gtklock --daemonize"
  | Waylock -> waylock ~palette:load_colors
