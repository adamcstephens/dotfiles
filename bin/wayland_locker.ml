open Dotfiles.Desktop
open Dotfiles.Process

let locker desktop =
  match desktop with
  | River -> "gtklock --daemonize"
  | Niri -> "gtklock --daemonize"

let do_lock ~cmd =
  match find_running_procs cmd with
  | Some existing_procs ->
      let pids =
        List.map (fun { pid; _ } -> pid) existing_procs |> String.concat ", "
      in
      Printf.sprintf "Locker already running: %s, pid(s): %s" cmd pids
      |> print_endline
  | None ->
      Printf.sprintf "Locking with command: %s" cmd |> print_endline;
      let _ = Sys.command cmd in
      ()

let () =
  match get_desktop with
  | Ok desktop -> do_lock ~cmd:(locker desktop)
  | Error err ->
      Printf.printf "Failure loading desktop: %s\n" (show_desktop_error err);
      exit 1
