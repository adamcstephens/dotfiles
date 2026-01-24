---
name: elixir-conventions
description: Guides Elixir development with project-specific conventions. Use when writing, refactoring, or reviewing Elixir code to ensure consistent patterns like struct usage, test practices, pattern matching, and code formatting.
---

# Elixir Conventions

Provides conventions and best practices for Elixir development in this project.

## Struct Usage

Prefer structs over bare maps using the `typedstruct` library:

```elixir
defmodule MyModule do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :email, String.t()
    field :age, integer(), default: 0
  end
end
```

If `typedstruct` is not installed, add to `mix.exs`:

```elixir
{:typedstruct, "~> 0.5"}
```

Access struct fields using dot notation (`struct.field`), never bracket notation (`struct[:field]`).

## Pattern Matching in Function Declarations

Pattern match on structs directly in function signatures:

```elixir
# Good
def process(%User{name: name, email: email}) do
  IO.puts("Processing #{name} (#{email})")
end

# Avoid
def process(user) do
  %User{name: name, email: email} = user
  IO.puts("Processing #{name} (#{email})")
end
```

This makes function intent clear and provides early validation including field checking.

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
