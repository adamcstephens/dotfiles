open Yojson.Basic.Util

let waylock =
  let home = Sys.getenv "HOME" in
  let palette =
    Yojson.Basic.from_file (Printf.sprintf "%s/.config/colorscheme.json" home)
    |> member "palette"
  in
  let init_color = palette |> member "base01" |> to_string in
  let input_color = palette |> member "base03" |> to_string in
  let fail_color = palette |> member "base08" |> to_string in
  Printf.sprintf
    "waylock -fork-on-lock -init-color 0x%s -input-color 0x%s -fail-color 0x%s"
    init_color input_color fail_color

let locker desktop =
  match desktop with
  | "river" ->
      Some waylock
  | "niri" ->
      Some "gtklock --daemonize"
  | _ ->
      None

let () =
  match Sys.getenv "XDG_CURRENT_DESKTOP" |> locker with
  | Some cmd ->
      Printf.sprintf "Locking with command: %s" cmd |> print_endline ;
      let _ = Sys.command cmd in
      ()
  | None ->
      print_endline "Unsupported desktop environment" ;
      exit 1
