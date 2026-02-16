(* Types *)
type theme_state = Dark | Light
type command = Enable | Disable | Toggle | Status | SyncTmux | WatchTmux

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

  let run_no_output cmd = Sys.command (cmd ^ " >/dev/null 2>&1") = 0
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
  let contains haystack needle =
    let hay_len = String.length haystack in
    let needle_len = String.length needle in
    let rec loop i =
      if i + needle_len > hay_len then false
      else if String.sub haystack i needle_len = needle then true
      else loop (i + 1)
    in
    loop 0

  let get_state () =
    match
      Util.run_command
        "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || \
         dconf read /org/gnome/desktop/interface/color-scheme 2>/dev/null"
    with
    | s when contains s "prefer-dark" -> Dark
    | _ -> (
        match Util.read_state () with
        | Some state -> state
        | None -> Light)

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
          "dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\""
        |> ignore
    | Light ->
        Util.run_command
          "gsettings-wrapper set org.gnome.desktop.interface color-scheme \
           prefer-light"
        |> ignore;
        Util.run_command
          "dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-light'\""
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
  | Platform.Linux -> Some (Linux.get_state ())
  | Platform.Unknown -> None

let set_dark_mode state =
  match Platform.current with
  | Platform.Darwin ->
      Darwin.set_theme state;
      Util.write_state state
  | Platform.Linux -> Linux.set_theme state
  | Platform.Unknown -> failwith "Unsupported platform"

let toggle_dark_mode () =
  match get_current_state () with
  | Some Dark -> set_dark_mode Light
  | Some Light | None -> set_dark_mode Dark

let tmux_theme_file = function
  | Dark -> "~/.config/tmux/theme-dark.conf"
  | Light -> "~/.config/tmux/theme-light.conf"

let apply_tmux_theme state =
  if Util.run_no_output "tmux list-sessions" then (
    let theme = tmux_theme_file state in
    let _ = Util.run_no_output ("tmux source-file " ^ theme) in
    let _ = Util.run_no_output "tmux refresh-client -S" in
    ())

let sync_tmux () =
  match get_current_state () with
  | Some state ->
      apply_tmux_theme state;
      Util.write_state state
  | None -> ()

let lock_file () =
  let base =
    match Sys.getenv_opt "XDG_RUNTIME_DIR" with
    | Some d -> d
    | None -> "/tmp"
  in
  Filename.concat base "tmux-theme-sync.lockfile"

let with_watch_lock f =
  let file = lock_file () in
  let fd =
    Unix.openfile file [ Unix.O_CREAT; Unix.O_RDWR; Unix.O_CLOEXEC ] 0o600
  in
  try
    Unix.lockf fd Unix.F_TLOCK 0;
    Fun.protect ~finally:(fun () -> Unix.close fd) f
  with
  | Unix.Unix_error ((Unix.EAGAIN | Unix.EACCES), _, _) ->
      (* Another watcher instance owns the lock; exit quietly. *)
      Unix.close fd
  | exn ->
      Unix.close fd;
      raise exn

let watch_tmux () =
  with_watch_lock (fun () ->
      let rec loop prev =
        let current = get_current_state () in
        if current <> prev then sync_tmux ();
        Unix.sleep 2;
        loop current
      in
      sync_tmux ();
      loop (get_current_state ()))

(* Command line parsing and main *)
let parse_args () =
  if Array.length Sys.argv = 2 then
    match String.lowercase_ascii Sys.argv.(1) with
    | "enable" -> Some Enable
    | "disable" -> Some Disable
    | "toggle" -> Some Toggle
    | "status" -> Some Status
    | "sync-tmux" -> Some SyncTmux
    | "watch-tmux" -> Some WatchTmux
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
  | Some SyncTmux -> sync_tmux ()
  | Some WatchTmux -> watch_tmux ()
  | None ->
      Printf.eprintf
        "Usage: %s [enable|disable|toggle|status|sync-tmux|watch-tmux]\n"
        Sys.argv.(0);
      exit 1
