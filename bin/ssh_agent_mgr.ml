open Unix

(* List of potential SSH agent sockets *)
let socket_candidates = [
  Sys.getenv_opt "XDG_RUNTIME_DIR" |> Option.map (fun dir -> dir ^ "/ssh-agent");
  Sys.getenv_opt "XDG_RUNTIME_DIR" |> Option.map (fun dir -> dir ^ "/yubikey-agent/yubikey-agent.sock");
  Sys.getenv_opt "XDG_RUNTIME_DIR" |> Option.map (fun dir -> dir ^ "/ssh-tpm-agent");
  Sys.getenv_opt "HOME" |> Option.map (fun home -> home ^ "/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh");
  Sys.getenv_opt "HOME" |> Option.map (fun home -> home ^ "/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock")
]

(* Check if a socket exists and is valid *)
let is_valid_socket path =
  match path with
  | Some p -> (try (stat p).st_kind = S_SOCK with _ -> false)
  | None -> false

(* Find the first valid socket *)
let find_valid_socket () =
  List.find_opt is_valid_socket socket_candidates |> Option.join

(* Set the SSH_AUTH_SOCK environment variable *)
let set_ssh_auth_sock socket =
  match socket with
  | Some sock -> Unix.putenv "SSH_AUTH_SOCK" sock
  | None -> ()

(* Check if the ssh-agent has keys *)
let ssh_agent_has_keys () =
  Sys.command "ssh-add -l >/dev/null 2>&1" = 0

(* Main logic *)
let () =
  (* Check if we're in a supported environment *)
  let initial_socket =
    if Sys.getenv_opt "TMUX" <> None || Sys.getenv_opt "SSH_TTY" <> None ||
       Sys.getenv_opt "ET_VERSION" <> None || Sys.getenv_opt "ZELLIJ" <> None
    then Sys.getenv_opt "SSH_AUTH_SOCK"
    else None
  in

  (* Find a valid socket if none is set *)
  let socket = match initial_socket with
    | Some sock -> Some sock
    | None -> find_valid_socket ()
  in

  (* Set the SSH_AUTH_SOCK environment variable *)
  set_ssh_auth_sock socket;

  (* Check if the agent has keys, and fallback if necessary *)
  if not (ssh_agent_has_keys ()) then (
    let fallback_socket = find_valid_socket () in
    set_ssh_auth_sock fallback_socket;

    if not (ssh_agent_has_keys ()) then
      prerr_endline "Empty ssh-agent"
  );

  (* Print the final socket path *)
  match Sys.getenv_opt "SSH_AUTH_SOCK" with
  | Some sock -> print_string sock
  | None -> ()
