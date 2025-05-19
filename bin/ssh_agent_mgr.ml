let socket_candidates =
  [
    Sys.getenv_opt "XDG_RUNTIME_DIR"
    |> Option.map (fun dir -> dir ^ "/yubikey-agent/yubikey-agent.sock");
    Sys.getenv_opt "XDG_RUNTIME_DIR"
    |> Option.map (fun dir -> dir ^ "/ssh-tpm-agent");
    Sys.getenv_opt "HOME"
    |> Option.map (fun home ->
           home
           ^ "/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh");
    Sys.getenv_opt "HOME"
    |> Option.map (fun home ->
           home
           ^ "/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock");
    Sys.getenv_opt "XDG_RUNTIME_DIR"
    |> Option.map (fun dir -> dir ^ "/ssh-agent");
  ]

let is_valid_socket path =
  match path with
  | Some p -> ( try (Unix.stat p).st_kind = S_SOCK with _ -> false)
  | None -> false

let find_valid_socket () =
  List.find_opt is_valid_socket socket_candidates |> Option.join

let set_ssh_auth_sock socket =
  match socket with Some sock -> Unix.putenv "SSH_AUTH_SOCK" sock | None -> ()

(* Check if the ssh-agent has keys *)
let ssh_agent_has_keys () = Sys.command "ssh-add -l >/dev/null 2>&1" = 0

(* Main logic *)
let () =
  let socket =
    if
      List.exists
        (fun var -> Option.is_some (Sys.getenv_opt var))
        [ "TMUX"; "SSH_TTY"; "ET_VERSION"; "ZELLIJ" ]
    then Sys.getenv_opt "SSH_AUTH_SOCK"
    else find_valid_socket ()
  in

  set_ssh_auth_sock socket;

  if not (ssh_agent_has_keys ()) then (
    prerr_endline "Socket has no keys, re-running socket find";
    let fallback_socket = find_valid_socket () in
    set_ssh_auth_sock fallback_socket;

    if not (ssh_agent_has_keys ()) then prerr_endline "Empty ssh-agent");

  (* Print the final socket path *)
  match Sys.getenv_opt "SSH_AUTH_SOCK" with
  | Some sock -> print_string sock
  | None -> ()
