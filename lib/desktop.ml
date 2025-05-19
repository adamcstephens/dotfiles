type desktop = Niri | River
type desktop_error = NotFound | Unsupported [@@deriving show]

let get_desktop =
  match Sys.getenv_opt "XDG_CURRENT_DESKTOP" with
  | Some "niri" -> Ok Niri
  | Some "river" -> Ok River
  | Some _ -> Error Unsupported
  | None -> Error NotFound
