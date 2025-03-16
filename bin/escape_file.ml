let is_symlink path =
  let stat = Unix.lstat path in
  stat.st_kind == S_LNK

let escape path real_path =
      Printf.sprintf "Escaping %s -> %s" real_path path
      |> print_endline;
      FileUtil.rm [path];
      FileUtil.cp [real_path] path ~recurse:true;
      FileUtil.chmod (`Symbolic [`User (`Add `Write)]) [path] ~recurse:true;
      print_endline "Done!"


let () =
  if Array.length Sys.argv != 2 then
    print_endline "Must include a path to escape"
  else
    let path = Sys.argv.(1) in
    if is_symlink path then
      let real_path = Unix.realpath path in
        escape path real_path
    else
      Printf.sprintf "Path %s must exist and be a symlink" path
      |> print_endline;
      exit 1
