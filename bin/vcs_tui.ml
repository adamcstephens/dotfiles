let well_known_socket =
  let base =
    match Sys.getenv_opt "XDG_RUNTIME_DIR" with
    | Some xdg_runtime_dir -> xdg_runtime_dir
    | None -> Sys.getenv "HOME" ^ "/.ssh"
  in
  base ^ "/ssh-auth.sock"

let tui =
  try
    let _ = Sys.is_directory ".jj" in
    Some "jjui"
  with Sys_error _ -> (
    try
      let _ = Sys.is_directory ".git" in
      Some "lazygit"
    with Sys_error _ -> None)

let () =
  match tui with
  | Some tui_exec ->
      let args = Array.sub Sys.argv 1 (Array.length Sys.argv - 1) in
      Unix.putenv "SSH_AUTH_SOCK" well_known_socket;
      Unix.execvp tui_exec (Array.append [| tui_exec |] args)
  | None ->
      Printf.eprintf "No VCS directory found";
      exit 1
