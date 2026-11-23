#!/usr/bin/env python3
import importlib.util
import json
import os
import shlex
import subprocess
import sys
import unittest
from importlib.machinery import SourceFileLoader
from pathlib import Path
from unittest.mock import call, patch

SCRIPT = Path(__file__).parents[1] / "bin" / "prj"
LOADER = SourceFileLoader("prj", str(SCRIPT))
SPEC = importlib.util.spec_from_loader(LOADER.name, LOADER)
assert SPEC is not None
prj = importlib.util.module_from_spec(SPEC)
LOADER.exec_module(prj)


def leaf(block_id, left, width):
    return {"block_id": block_id, "rect": [left, 0, width, 1]}


def split(before, after, ratio=0.5, direction="horizontal"):
    return {"split": {"direction": direction, "ratio": ratio, "before": before, "after": after}}


def window(layout, label="project", window_id="window:project"):
    return {
        "window_id": window_id,
        "label": label,
        "layers": [{"kind": "tiled", "bounds": [0, 0, 1, 1], "layout": layout}],
    }


class RexTest(unittest.TestCase):
    def setUp(self):
        self.enterContext(patch.dict(os.environ, {"REX_BLOCK": "block:caller"}, clear=True))
        for name in ("is_kitty", "is_tmux", "is_tuios", "is_wayland", "is_zellij"):
            self.enterContext(patch.object(prj, name, False))
        self.enterContext(patch.object(prj, "is_rex", True))

    def test_api_scopes_every_call_to_originating_session(self):
        with patch.object(prj, "run", return_value='{"revision": 1}') as run:
            result = prj.rex_api("session.focus_window", {"window_id": "window:project"})
        self.assertEqual(result, {"revision": 1})
        (command,) = run.call_args.args
        self.assertEqual(shlex.split(command), ["rex", "api", "call", "session.focus_window", "-"])
        self.assertEqual(
            json.loads(run.call_args.kwargs["input"]),
            {"session_id": "block:caller", "window_id": "window:project"},
        )

    def test_finder_uses_native_rex_picker(self):
        with patch.object(prj, "run", return_value='{"project": "/src/my project"}') as run:
            self.assertEqual(prj.prj_finder(), "/src/my project")
        run.assert_called_once_with("rex do prj_pick --json")

    def test_finder_cancellation(self):
        with patch.object(prj, "run", return_value='{"project": ""}') as run:
            self.assertEqual(prj.prj_finder(), "")
        run.assert_called_once_with("rex do prj_pick --json")

    def test_finder_propagates_rex_failure(self):
        with patch.object(prj, "run", side_effect=SystemExit(1)), self.assertRaises(SystemExit):
            prj.prj_finder()

    def test_nested_backends_keep_fzf(self):
        for backend in ("is_tmux", "is_tuios", "is_zellij"):
            with (
                self.subTest(backend=backend),
                patch.object(prj, backend, True),
                patch.object(prj, "run", side_effect=["/src/project", "/src/project"]) as run,
            ):
                self.assertEqual(prj.prj_finder(), "/src/project")
                self.assertEqual(
                    run.call_args_list,
                    [call("zoxide query --list"), call(prj.FINDER, input="/src/project")],
                )

    def test_rex_rejects_remote_flags_before_running_commands(self):
        env = {"REX_BLOCK": "block:caller", "PATH": ""}
        for flag in ("--remote", "--ssh", "-r", "-s"):
            with self.subTest(flag=flag):
                result = subprocess.run(
                    [sys.executable, str(SCRIPT), flag],
                    env=env,
                    capture_output=True,
                    text=True,
                    check=False,
                )
                self.assertEqual(result.returncode, 2)
                self.assertIn("--remote and --ssh are not supported in rex", result.stderr)
                self.assertEqual(result.stdout, "")

    def test_explicit_project_bypasses_picker_and_uses_absolute_path(self):
        code = """
import json
import os
import runpy
import subprocess
import sys
from unittest.mock import patch

def command(command, **kwargs):
    print(json.dumps({
        "command": command,
        "block": os.environ.get("REX_BLOCK"),
        "client": os.environ.get("REX_CLIENT"),
    }))
    return subprocess.CompletedProcess(command, 0, "null", "")

sys.argv = [sys.argv[1], "--", "my-project"]
with patch("subprocess.run", side_effect=command):
    runpy.run_path(sys.argv[0], run_name="__main__")
"""
        result = subprocess.run(
            [sys.executable, "-c", code, str(SCRIPT)],
            env={"REX_BLOCK": "block:caller", "REX_CLIENT": "client:test", "PATH": ""},
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(f":: Opening project {os.path.abspath('my-project')}", result.stdout)
        commands = [json.loads(line) for line in result.stdout.splitlines() if line.startswith("{")]
        self.assertEqual(len(commands), 1)
        argv = shlex.split(commands[0]["command"])
        self.assertEqual(argv[:4], ["rex", "do", "prj_open", "--args"])
        self.assertEqual(
            json.loads(argv[4]),
            {"project": os.path.abspath("my-project"), "window_label": "my-project"},
        )
        self.assertEqual(commands[0]["block"], "block:caller")
        self.assertEqual(commands[0]["client"], "client:test")

    def test_open_window_delegates_to_native_action(self):
        project = "/src/my project's directory"
        with patch.object(prj, "run") as run, patch.object(prj, "direnv_allowed") as allowed:
            prj.rex_open_window("my-project", project)
        run.assert_called_once()
        argv = shlex.split(run.call_args.args[0])
        self.assertEqual(argv[:4], ["rex", "do", "prj_open", "--args"])
        self.assertEqual(json.loads(argv[4]), {"project": project, "window_label": "my-project"})
        allowed.assert_not_called()

    def test_project_dispatches_to_rex(self):
        with patch.object(prj, "run") as run, patch.object(prj, "rex_open_window") as open_window:
            prj.open_project("/src/my-project")
        open_window.assert_called_once_with("my-project", "/src/my-project")
        run.assert_not_called()

    def test_rex_takes_precedence_over_kitty(self):
        with (
            patch.object(prj, "is_kitty", True),
            patch.object(prj, "run") as run,
            patch.object(prj, "rex_open_window") as open_window,
            patch.object(prj, "kitty_active_window") as kitty,
        ):
            prj.open_project("/src/project")
        open_window.assert_called_once_with("project", "/src/project")
        run.assert_not_called()
        kitty.assert_not_called()

    def test_nested_tuios_takes_precedence(self):
        with (
            patch.object(prj, "is_tuios", True),
            patch.object(prj, "run") as run,
            patch.object(prj, "tuios_workspace", return_value=None) as workspace,
            patch.object(prj, "rex_open_window") as open_window,
        ):
            prj.open_project("/src/project")
        workspace.assert_called_once_with("project")
        open_window.assert_not_called()
        run.assert_called_once_with("zoxide add /src/project")

    def test_nested_tmux_takes_precedence(self):
        with (
            patch.object(prj, "is_tmux", True),
            patch.object(prj, "run", side_effect=["", "1,project", ""]) as run,
            patch.object(prj, "rex_open_window") as open_window,
        ):
            prj.open_project("/src/project")
        open_window.assert_not_called()
        self.assertEqual(run.call_args, call("tmux select-window -t project"))
        self.assertEqual(run.call_args_list[0], call("zoxide add /src/project"))

    def test_nested_zellij_takes_precedence(self):
        with (
            patch.object(prj, "is_zellij", True),
            patch.object(prj, "run", side_effect=["", "project", ""]) as run,
            patch.object(prj, "rex_open_window") as open_window,
        ):
            prj.open_project("/src/project")
        open_window.assert_not_called()
        self.assertEqual(run.call_args, call("zellij action go-to-tab-name project"))
        self.assertEqual(run.call_args_list[0], call("zoxide add /src/project"))

    def test_relayout_balances_two_columns_and_skips_other_layouts(self):
        left, middle, right = leaf("left", 0, 0.25), leaf("middle", 0.25, 0.5), leaf("right", 0.75, 0.25)
        layouts = [
            split(left, split(middle, right)),
            split(left, right),
            split(left, right, direction="vertical"),
            left,
        ]
        with (
            patch.object(prj, "rex_api", return_value={}) as api,
            patch("builtins.print") as output,
        ):
            api.side_effect = [{"windows": [window(layout) for layout in layouts]}, {}]
            prj.rex_relayout()
        resizes = [c.args[1] for c in api.call_args_list if c.args[0] == "session.resize_pane"]
        self.assertEqual(
            resizes,
            [{"direction": "horizontal", "before_block_id": "left", "after_block_id": "right", "ratio": 0.5}],
        )
        output.assert_called_once_with("relayout: 1 sized, 3 skipped")


if __name__ == "__main__":
    unittest.main()
