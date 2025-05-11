(lang dune 3.17)

(name dotfiles)

(generate_opam_files true)

(license UNLICENSE)

(package
 (name dotfiles)
 (depends ocaml eio_main fileutils ppx_deriving utop yojson))
