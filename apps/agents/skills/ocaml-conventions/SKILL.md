---
name: ocaml-conventions
description: Guides OCaml development with practical project conventions. Use when writing, refactoring, or reviewing OCaml code to keep modules, types, errors, and formatting consistent.
---

# OCaml Conventions

Provides conventions and best practices for OCaml development in this project.

## Module and File Structure

- Keep one primary module per file, with matching names (`user.ml`/`user.mli` -> `User`).
- Prefer small, focused modules over large utility files.
- Expose only stable public APIs in `.mli` files; keep implementation helpers private in `.ml`.

## Type-Driven Design

- Model domain states with variants and records instead of ad-hoc strings or tuples.
- Prefer explicit named records for multi-field values.
- Add constructors for meaningful states rather than encoding state in booleans.

```ocaml
(* Good *)
type status = Draft | Published | Archived

type article = {
  id : int;
  title : string;
  status : status;
}
```

```ocaml
(* Avoid *)
type article = int * string * string
```

## Error Handling

- Use `('a, 'e) result` for recoverable failures.
- Use custom error variants for domain errors instead of raw strings.
- Reserve exceptions for truly exceptional or boundary-level failures.

```ocaml
type create_user_error =
  | Empty_name
  | Invalid_email

let create_user ~name ~email =
  if String.length name = 0 then Error Empty_name
  else if not (String.contains email '@') then Error Invalid_email
  else Ok (name, email)
```

## Pattern Matching

- Prefer exhaustive `match` expressions.
- Avoid catch-all (`_`) when handling domain variants; list constructors explicitly.
- Keep each match branch simple; extract branch logic into named helpers when needed.

## Function Style

- Prefer pure functions with explicit inputs/outputs.
- Use labeled arguments for readability when a function takes more than two parameters.
- Keep functions small and composable.

```ocaml
let build_user ~id ~name ~email = { id; name; email }
```

## Collections and Option/Result Utilities

- Prefer `List`/`Array`/`Seq` stdlib operations over handwritten loops for transformations.
- Use `Option.map`, `Option.bind`, `Result.map`, and `Result.bind` for straightforward pipelines.
- Avoid deeply nested matches when combinators keep intent clear.

## State and Mutability

- Default to immutable data structures.
- Limit mutable refs/fields to well-contained performance or interop boundaries.
- Keep side effects at the edges (IO modules, adapters, CLI entrypoints).

## Naming and Readability

- Use descriptive names (`find_user_by_id`) over abbreviated names (`fubid`).
- Use `snake_case` for values/functions and `PascalCase` for modules/constructors.
- Keep constructor names meaningful and domain-specific.

## Testing

- Test behavior at public module boundaries.
- Prefer deterministic tests with explicit inputs/outputs.
- For pure functions, use table-driven tests where practical.
- Avoid mocking unless required by external boundaries.

## Formatting and Tooling

- Always format code with `ocamlformat`.
- Keep builds and checks passing with `dune`.

```bash
# Format project files
ocamlformat -i $(git ls-files '*.ml' '*.mli')

# Run tests
dune test

# Build all targets
dune build
```

If a project already defines style/tooling defaults in `dune-project`, `.ocamlformat`, or CI config, follow those project settings.
