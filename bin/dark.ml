(* Types *)
type theme_state = Dark | Light
type command = Enable | Disable | Toggle | Status

(* Module for platform-specific operations *)
module Platform = struct
  type t = Darwin | Linux | Unknown

  let current =
    match Sys.os_type with
    | "Unix" ->
        if Sys.command "uname | grep -q Darwin" = 0 then Darwin else Linux
    | _ -> Unknown
end

(* Configuration *)
module Config = struct
  let state_file =
    match Sys.getenv_opt "HOME" with
    | Some home -> Filename.concat home ".dotfiles/.dark-mode.state"
    | None -> failwith "HOME environment variable not set"
end

(* Utilities *)
module Util = struct
  let run_command cmd =
    Printf.printf "Running: %s\n" cmd;
    try
      let ic = Unix.open_process_in cmd in
      let result = input_line ic in
      let _ = Unix.close_process_in ic in
      result
    with End_of_file ->
      let _ = Unix.close_process_in (Unix.open_process_in cmd) in
      ""

  let write_state state =
    let oc = open_out Config.state_file in
    output_string oc (if state = Dark then "true" else "false");
    close_out oc

  let read_state () =
    try
      let ic = open_in Config.state_file in
      let state = input_line ic = "true" in
      close_in ic;
      Some (if state then Dark else Light)
    with _ -> None
end

(* Darwin specific operations *)
module Darwin = struct
  let get_state () =
    match Util.run_command "/opt/homebrew/bin/dark-mode status" with
    | "on" -> Dark
    | _ -> Light

  let set_theme = function
    | Dark -> Util.run_command "/opt/homebrew/bin/dark-mode on" |> ignore
    | Light -> Util.run_command "/opt/homebrew/bin/dark-mode off" |> ignore
end

(* Linux specific operations *)
module Linux = struct
  let set_gtk_theme = function
    | Dark ->
        Util.run_command
          "gsettings-wrapper set org.gnome.desktop.interface gtk-theme \
           Flat-Remix-GTK-Orange-Darkest-Solid"
        |> ignore
    | Light ->
        Util.run_command
          "gsettings-wrapper set org.gnome.desktop.interface gtk-theme \
           Flat-Remix-GTK-Orange-Light-Solid"
        |> ignore

  let set_gnome_scheme = function
    | Dark ->
        Util.run_command
          "gsettings-wrapper set org.gnome.desktop.interface color-scheme \
           prefer-dark"
        |> ignore;
        Util.run_command
          "dconf write /org/gnome/desktop/interface/color-scheme 'prefer-dark'"
        |> ignore
    | Light ->
        Util.run_command
          "gsettings-wrapper set org.gnome.desktop.interface color-scheme \
           prefer-light"
        |> ignore;
        Util.run_command
          "dconf write /org/gnome/desktop/interface/color-scheme 'prefer-light'"
        |> ignore

  let set_theme state =
    set_gtk_theme state;
    set_gnome_scheme state;
    Util.write_state state
end

(* Core functionality *)
let get_current_state () =
  match Platform.current with
  | Platform.Darwin -> Some (Darwin.get_state ())
  | Platform.Linux -> Util.read_state ()
  | Platform.Unknown -> None

let set_dark_mode state =
  match Platform.current with
  | Platform.Darwin -> Darwin.set_theme state
  | Platform.Linux -> Linux.set_theme state
  | Platform.Unknown -> failwith "Unsupported platform"

let toggle_dark_mode () =
  match get_current_state () with
  | Some Dark -> set_dark_mode Light
  | Some Light | None -> set_dark_mode Dark

(* Command line parsing and main *)
let parse_args () =
  if Array.length Sys.argv = 2 then
    match String.lowercase_ascii Sys.argv.(1) with
    | "enable" -> Some Enable
    | "disable" -> Some Disable
    | "toggle" -> Some Toggle
    | "status" -> Some Status
    | _ -> None
  else None

let () =
  match parse_args () with
  | Some Enable -> set_dark_mode Dark
  | Some Disable -> set_dark_mode Light
  | Some Toggle -> toggle_dark_mode ()
  | Some Status ->
      let state =
        match get_current_state () with
        | Some Dark -> "true"
        | Some Light | None -> "false"
      in
      print_endline state
  | None ->
      Printf.eprintf "Usage: %s [enable|disable|toggle|status]\n" Sys.argv.(0);
      exit 1
