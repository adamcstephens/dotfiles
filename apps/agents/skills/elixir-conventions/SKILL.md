---
name: elixir-conventions
description: Guides Elixir development with project-specific conventions. Use when writing, refactoring, or reviewing Elixir code to ensure consistent patterns like struct usage, test practices, pattern matching, and code formatting.
---

# Elixir Conventions

Provides conventions and best practices for Elixir development in this project.

## Struct Usage

Always define structured data with the `typedstruct` library. Never use bare maps for struct-like data, and never use `defstruct`.

```elixir
# Good
defmodule MyModule do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :email, String.t()
    field :age, integer(), default: 0
  end
end
```

Ensure `typedstruct` is installed in `mix.exs`:

```elixir
{:typedstruct, "~> 0.5"}
```

```elixir
# Avoid
defmodule MyModule do
  defstruct [:name, :email, :age]
end
```

```elixir
# Avoid
user = %{name: "Jane", email: "jane@example.com", age: 30}
```

Access struct fields using dot notation (`struct.field`) when struct presence is guaranteed, never bracket notation (`struct[:field]`).

## Nil-Safe Struct Field Lookup

When an expected struct may be `nil`, use `get_in/2` for field lookup so the result is the field value or `nil` without raising.

```elixir
# Good
value = get_in(my_struct.myval)
email = get_in(user.email)
```

```elixir
# Avoid - raises if struct is nil
value = my_struct.myval
```

## Pattern Matching in Function Declarations

If an argument is a struct, always make that explicit in the function signature.

Only match struct fields in the signature when those fields control function clause selection flow. Do not match fields just to extract them into local variables.

```elixir
# Good - explicit struct, fields read in body
def process(%User{} = user) do
  IO.puts("Processing #{user.name} (#{user.email})")
end

# Good - field matching used for clause selection flow
def route_user(%User{role: :admin} = user), do: route_admin(user)
def route_user(%User{} = user), do: route_member(user)

# Avoid - matching fields only for extraction
def process(%User{name: name, email: email}) do
  IO.puts("Processing #{name} (#{email})")
end

# Avoid - struct type not explicit in signature
def process(user) do
  %User{name: name, email: email} = user
  IO.puts("Processing #{name} (#{email})")
end
```

This keeps clause intent explicit and avoids coupling field extraction with function dispatch logic.

## Test Practices

### Capturing Logs

Use `ExUnit.CaptureLog.capture_log/1` to capture and assert on logs:

```elixir
import ExUnit.CaptureLog

test "logs when processing fails" do
  logs = capture_log(fn ->
    MyModule.process(%User{name: "John"})
  end)

  assert logs =~ "Processing John"
end
```

## Error Handling

Do not throw messages. Only use catch/rescue when absolutely required:

```elixir
# Good - use tuples
def parse(data) do
  case Integer.parse(data) do
    {num, ""} -> {:ok, num}
    _ -> {:error, "Invalid integer"}
  end
end

# Avoid
def parse(data) do
  throw("Invalid integer")
end

# Only rescue when necessary
def risky_operation do
  try do
    external_api_call()
  rescue
    e in HTTPError -> {:error, "API failed: #{e.message}"}
  end
end
```

Use `{:ok, value}` and `{:error, reason}` tuples for explicit error handling.

## Nil Fallbacks

When a value may be `nil`, use the `||` fallback pattern directly (for example, `item || %{}`).

Do not use inline conditionals for this (`if`, `case`, or similar), and avoid helper functions that only wrap the same fallback behavior.

```elixir
# Good
attrs = attrs || %{}
metadata = metadata || %{}
```

```elixir
# Avoid - inline conditional
attrs = if attrs == nil, do: %{}, else: attrs
```

```elixir
# Avoid - needless helper wrapper
defp ensure_map(value), do: value || %{}

attrs = ensure_map(attrs)
```

## With Statements

Always handle failed matches and errors in `with` expressions using an `else` branch.

```elixir
# Good
def create_user(params) do
  with {:ok, attrs} <- parse_user_params(params),
       {:ok, user} <- Repo.insert(attrs) do
    {:ok, user}
  else
    {:error, reason} -> {:error, reason}
    other -> {:error, "Unexpected with failure: #{inspect(other)}"}
  end
end
```

```elixir
# Avoid
def create_user(params) do
  with {:ok, attrs} <- parse_user_params(params),
       {:ok, user} <- Repo.insert(attrs) do
    {:ok, user}
  end
end
```

## Logging

Logger messages should be structured, with relevant information included as discrete fields. Field values must be simple strings or safely converted to strings—a log should never crash, and output should be parseable as simple key/value JSON fields:

```elixir
# Good - structured with simple string values
Logger.error(msg: "Something bad happened", important_id: to_string(id), error: Exception.message(error))
Logger.info(msg: "User created", user_id: to_string(user.id), email: user.email)

# Good - safely convert complex values
Logger.warning(msg: "Request failed", params: inspect(params, limit: :infinity))

# Avoid - unstructured string interpolation
Logger.error("Something bad happened: #{inspect(error)} for id #{id}")

# Avoid - complex values that may not serialize cleanly
Logger.error(msg: "Failed", data: some_struct, error: an_error_tuple)
```

## Typespecs

Never add `@spec` or `@type` annotations. The `typedstruct` library handles type definitions for structs. Do not add typespecs to functions.

## Callback Implementations

Always use explicit module names with `@impl`, not `@impl true`:

```elixir
# Good - explicit module
@impl GenServer
def handle_call(:get_state, _from, state) do
  {:reply, state, state}
end

@impl Plug
def call(conn, opts) do
  # ...
end

# Avoid - ambiguous
@impl true
def handle_call(:get_state, _from, state) do
  {:reply, state, state}
end
```

This makes it clear which behaviour the callback implements, especially in modules implementing multiple behaviours.

## List Literals

Always write lists using standard list literal syntax:

```elixir
# Good - atom list
allowed_keys = [:name, :email, :age]

# Good - string list
names = ["alice", "bob", "carol"]
```

Do not use sigils for lists (for example, avoid `~w(name email age)a` and `~w(alice bob carol)`).

## Code Formatting

Always run `mix format` after changes:

```bash
# Format all code
mix format

# Format specific files
mix format path/to/file.ex

# Format tests when making small changes
mix format test/
```

Verify formatting with the full suite when done:

```bash
mix format --check-formatted
```

This ensures consistent style across the project with 2-space indentation and no trailing whitespace.
