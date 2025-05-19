(* open Eio *)

let ( / ) = Eio.Path.( / )

type process = { pid : string; cmd : string }

(* Use our own read_file, since Eio.Path.load doesn't seem to like null terminated files *)
let read_file path =
  try
    Eio.Path.with_open_in path @@ fun flow ->
    let buf = Eio.Buf_read.of_flow flow ~max_size:Int.max_int in
    Eio.Buf_read.take_all buf
  with _ -> ""

let load_procs ~proc =
  Eio.Path.with_open_dir proc @@ fun dir ->
  let contents = Eio.Path.read_dir dir in
  List.filter (fun { pid = _; cmd } -> not (String.equal cmd ""))
  @@ List.map (fun pid ->
         let cmdline = proc / pid / "cmdline" |> read_file in
         let cmdline =
           Str.global_replace (Str.regexp "\x00") " " cmdline |> String.trim
         in
         { pid; cmd = cmdline })
  @@ List.filter (fun c -> Str.string_match (Str.regexp "^[0-9]+$") c 0)
  @@ contents

let find_proc to_check ~proc =
  List.filter (fun { pid = _; cmd } ->
      try
        let _ = Str.search_forward (Str.regexp_string to_check) cmd 0 in
        true
      with Not_found -> false)
  @@ load_procs ~proc

let find_running_procs cmd =
  Eio_main.run @@ fun env ->
  let matched_procs = find_proc cmd ~proc:(Eio.Stdenv.fs env / "/proc") in
  if List.is_empty matched_procs then None else Some matched_procs
