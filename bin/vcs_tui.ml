open Dotfiles.Vcs

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  Logs.set_level (Some Logs.Debug)

let well_known_socket =
  let base =
    match Sys.getenv_opt "XDG_RUNTIME_DIR" with
    | Some xdg_runtime_dir -> xdg_runtime_dir
    | None -> Sys.getenv "HOME" ^ "/.ssh"
  in
  base ^ "/ssh-auth.sock"

let tui =
  Logs.debug (fun m -> m "Finding tui");
  match find_vcs_up with
  | Some Jujutsu -> Some "jjui"
  | Some Git -> Some "lazygit"
  | None -> None

let () =
  match tui with
  | Some tui_exec ->
      let args = Array.sub Sys.argv 1 (Array.length Sys.argv - 1) in
      Unix.putenv "SSH_AUTH_SOCK" well_known_socket;
      Logs.debug (fun m -> m "Found tui: %s" tui_exec);
      Unix.execvp tui_exec (Array.append [| tui_exec |] args)
  | None ->
      Logs.err (fun m -> m "No VCS directory found");
      exit 1
