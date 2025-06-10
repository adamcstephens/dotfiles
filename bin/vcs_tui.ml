type vcs = Git | Jujutsu

let well_known_socket =
  let base =
    match Sys.getenv_opt "XDG_RUNTIME_DIR" with
    | Some xdg_runtime_dir -> xdg_runtime_dir
    | None -> Sys.getenv "HOME" ^ "/.ssh"
  in
  base ^ "/ssh-auth.sock"

let get_vcs dir =
  try
    let _ = Sys.is_directory @@ Filename.concat dir ".jj" in
    Some Jujutsu
  with Sys_error _ -> (
    try
      let _ = Sys.is_directory @@ Filename.concat dir ".git" in
      Some Git
    with Sys_error _ -> None)

let rec walk_dir_up_f dir func =
  if dir = Sys.getenv "HOME" || dir = "/" then None
  else
    match func dir with
    | Some value -> Some value
    | None -> walk_dir_up_f (Filename.dirname dir) func

let find_vcs_up = walk_dir_up_f (Sys.getcwd ()) get_vcs

let tui =
  match find_vcs_up with
  | Some Jujutsu -> Some "jjui"
  | Some Git -> Some "lazygit"
  | None -> None

let () =
  match tui with
  | Some tui_exec ->
      let args = Array.sub Sys.argv 1 (Array.length Sys.argv - 1) in
      Unix.putenv "SSH_AUTH_SOCK" well_known_socket;
      Unix.execvp tui_exec (Array.append [| tui_exec |] args)
  | None ->
      Printf.eprintf "No VCS directory found\n";
      exit 1
