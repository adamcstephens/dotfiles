open Yojson.Basic.Util
open Dotfiles.Process

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
      let _ =
        match Dotfiles.Process.find_running_procs cmd with
        | Some existing_procs ->
            let pids =
              List.map (fun {pid; _} -> pid) existing_procs
              |> String.concat ", "
            in
            Printf.sprintf "Locker already running: %s, pid(s): %s" cmd pids
            |> print_endline ;
            0
        | None ->
            Printf.sprintf "Locking with command: %s" cmd |> print_endline ;
            Sys.command cmd
      in
      ()
  | None ->
      print_endline "Unsupported desktop environment" ;
      exit 1
