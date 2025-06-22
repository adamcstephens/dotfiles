open Dotfiles.Desktop

type target = On | Off

let target_name = function On -> "on" | Off -> "off"
let name_target = function "on" -> Some On | "off" -> Some Off | _ -> None

let switch_monitor ~desktop ~target =
  let target = target_name target in
  match desktop with
  | River -> Printf.sprintf "wlopm --%s '*'" target
  | Niri -> Printf.sprintf "niri msg action power-%s-monitors" target

let () =
  if Array.length Sys.argv != 2 then (
    print_endline "Must include argument of on or off";
    exit 1)
  else
    match name_target Sys.argv.(1) with
    | Some target -> (
        match get_desktop with
        | Ok desktop ->
            let cmd = switch_monitor ~desktop ~target in
            Printf.printf "Running command: %s" cmd;
            let _ = Sys.command cmd in
            ()
        | Error err ->
            Printf.printf "Failure loading desktop: %s\n"
              (show_desktop_error err);
            exit 1)
    | None ->
        print_endline "Must include argument of on or off";
        exit 1
