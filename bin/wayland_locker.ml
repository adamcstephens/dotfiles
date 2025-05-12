open Yojson.Basic.Util
open Dotfiles.Desktop
open Dotfiles.Process

let waylock ~palette =
  let init_color = palette |> member "base01" |> to_string in
  let input_color = palette |> member "base03" |> to_string in
  let fail_color = palette |> member "base08" |> to_string in
  Printf.sprintf
    "waylock -fork-on-lock -init-color 0x%s -input-color 0x%s -fail-color 0x%s"
    init_color input_color fail_color

let load_colors =
  let home = Sys.getenv "HOME" in
  Yojson.Basic.from_file (Printf.sprintf "%s/.config/colorscheme.json" home)
  |> member "palette"

let locker desktop =
  match desktop with
  | River ->
      waylock ~palette:load_colors
  | Niri ->
      "gtklock --daemonize"

let do_lock ~cmd =
  match find_running_procs cmd with
  | Some existing_procs ->
      let pids =
        List.map (fun {pid; _} -> pid) existing_procs |> String.concat ", "
      in
      Printf.sprintf "Locker already running: %s, pid(s): %s" cmd pids
      |> print_endline
  | None ->
      Printf.sprintf "Locking with command: %s" cmd |> print_endline ;
      let _ = Sys.command cmd in
      ()

let () =
  match get_desktop with
  | Ok desktop ->
      do_lock ~cmd:(locker desktop)
  | Error err ->
      Printf.printf "Failure loading desktop: %s\n" (show_desktop_error err) ;
      exit 1
