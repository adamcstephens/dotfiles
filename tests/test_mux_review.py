#!/usr/bin/env python3
import base64
import importlib.util
import io
import json
import os
import unittest
from contextlib import redirect_stdout
from importlib.machinery import SourceFileLoader
from pathlib import Path
from unittest.mock import Mock, patch

SCRIPT = Path(__file__).parents[1] / "bin" / "mux-review"
LOADER = SourceFileLoader("mux_review", str(SCRIPT))
SPEC = importlib.util.spec_from_loader(LOADER.name, LOADER)
assert SPEC is not None
mux_review = importlib.util.module_from_spec(SPEC)
LOADER.exec_module(mux_review)


def state_sequence(state, message):
    encoded = base64.b64encode(message.encode()).decode()
    return f"\033]7501;state={state}:app=mux-review:msg={encoded}\033\\"


class ReviewTest(unittest.TestCase):
    def test_worker_reports_states_and_waits_for_every_exit_status(self):
        for backend in ("REX_SESSION", "TUIOS_SESSION"):
            for status, expected_status in ((0, 0), (1, 1), (42, 42), (-15, 143)):
                with self.subTest(backend=backend, status=status):
                    self.check_worker(backend, status, expected_status)

    def check_worker(self, backend, status, expected_status):
        output = io.StringIO()
        working = state_sequence("working", "Reviewing PR 123")
        result = "completed" if status == 0 else f"failed (exit {status})"
        terminal = state_sequence("done" if status == 0 else "error", f"Review of PR 123 {result}")

        def run(command, *, check):
            self.assertEqual(output.getvalue(), working)
            return Mock(returncode=status)

        def close():
            self.assertEqual(
                output.getvalue(),
                working + terminal + f"\nReview {result}. Press Enter to close.",
            )
            return "\n"

        with (
            patch.dict(os.environ, {backend: "session:test"}, clear=True),
            patch.object(mux_review.sys, "platform", "linux"),
            patch.object(mux_review.subprocess, "run", side_effect=run) as process,
            patch.object(mux_review.sys, "stdin") as stdin,
            redirect_stdout(output),
        ):
            stdin.readline.side_effect = close
            self.assertEqual(mux_review.run_review("123", ["--no-shell"]), expected_status)
            stdin.readline.assert_called_once_with()
        process.assert_called_once_with(
            ["direnv", "exec", ".", "nixpkgs-review", "pr", "123", "--no-shell"], check=False
        )

    def test_worker_uses_caffeinate_on_darwin(self):
        with (
            patch.object(mux_review.sys, "platform", "darwin"),
            patch.object(mux_review.subprocess, "run", return_value=Mock(returncode=0)) as process,
            patch.object(mux_review.sys, "stdin"),
            redirect_stdout(io.StringIO()),
        ):
            self.assertEqual(mux_review.run_review("123", []), 0)
        process.assert_called_once_with(
            ["caffeinate", "direnv", "exec", ".", "nixpkgs-review", "pr", "123"], check=False
        )

    def test_rex_opens_minimized_in_the_callers_window(self):
        with (
            patch.dict(
                os.environ,
                {"REX_SESSION": "session:test", "REX_BLOCK": "block:caller", "TUIOS_SESSION": "nested"},
                clear=True,
            ),
            patch.object(mux_review.sys, "argv", ["mux-review", "123", "--foo"]),
            patch.object(mux_review.subprocess, "run", return_value=Mock(returncode=7)) as process,
        ):
            self.assertEqual(mux_review.main(), 7)
        (command,) = process.call_args.args
        self.assertEqual(process.call_args.kwargs, {"check": False})
        self.assertEqual(command[:7], ["rex", "do", "--session", "session:test", "--block", "block:caller", "--eval"])
        self.assertEqual(command[8], "--args")
        self.assertEqual(
            json.loads(command[9]),
            {
                "label": "review-123",
                "cwd": os.getcwd(),
                "command": [
                    "sh",
                    "-c",
                    'origin=$1; shift; "$@"; status=$?; rex block focus --session "$REX_SESSION" "$origin"; exit "$status"',
                    "sh",
                    "block:caller",
                    mux_review.sys.executable,
                    str(SCRIPT.resolve()),
                    "--worker",
                    "123",
                    "--no-shell",
                    "--post-result",
                    "--foo",
                ],
            },
        )
        script = command[7]
        self.assertIn("rex.session.describe_block({ block_id = rex.block_id })", script)
        self.assertIn("window_id = origin.block.window_id", script)
        self.assertIn("focus = false", script)
        self.assertIn('rex.call("session.set_layer_state"', script)
        self.assertIn("layer_id = layer.layer_id", script)
        self.assertIn('state = "minimized"', script)

    def test_tuios_keeps_worker_arguments_and_launcher_status(self):
        with (
            patch.dict(os.environ, {"TUIOS_SESSION": "session:test"}, clear=True),
            patch.object(mux_review.sys, "argv", ["mux-review", "https://github.com/NixOS/nixpkgs/pull/123", "--foo"]),
            patch.object(mux_review.subprocess, "run", return_value=Mock(returncode=7)) as process,
        ):
            self.assertEqual(mux_review.main(), 7)
        process.assert_called_once_with(
            [
                "tuios",
                "new-window",
                "123",
                "--cwd",
                os.getcwd(),
                "--",
                mux_review.sys.executable,
                str(SCRIPT.resolve()),
                "--worker",
                "123",
                "--no-shell",
                "--post-result",
                "--foo",
            ],
            check=False,
        )


if __name__ == "__main__":
    unittest.main()
