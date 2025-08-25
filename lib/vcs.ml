type vcs = Git | Jujutsu

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
  Logs.debug (fun m -> m "Walking dir: %s" dir);
  if dir = Sys.getenv "HOME" || dir = "/" then None
  else
    match func dir with
    | Some value -> Some value
    | None -> walk_dir_up_f (Filename.dirname dir) func

let find_vcs_up = walk_dir_up_f (Sys.getcwd ()) get_vcs
