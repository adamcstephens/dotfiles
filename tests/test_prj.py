#!/usr/bin/env python3
import importlib.util
import json
import os
import shlex
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
        self.enterContext(patch.dict(os.environ, {"REX_SESSION": "session:test", "REX_BLOCK": "block:caller"}))
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
            {"session_id": "session:test", "window_id": "window:project"},
        )

    def test_finder_uses_fzf_in_rex(self):
        with patch.object(prj, "run", side_effect=["/src/project", "/src/project"]) as run:
            self.assertEqual(prj.prj_finder(), "/src/project")
        self.assertEqual(run.call_args, call(prj.FINDER, input="/src/project"))

    def test_width_accounts_for_callers_split(self):
        view = {"windows": [window(split(leaf("block:caller", 0, 0.4), leaf("other", 0.4, 0.6)))]}
        with patch.object(prj, "rex_api", return_value={"columns": 120}) as api:
            self.assertEqual(prj.rex_window_width(view), 300)
        self.assertEqual(
            api.call_args,
            call("com.superlogical.terminal.size", {"block_id": "block:caller", "args": {}}),
        )

    def create_window(self, project="/src/project", host=None, allowed=False):
        api = self.enterContext(
            patch.object(
                prj,
                "rex_api",
                side_effect=[{"windows": []}, {"block_ids": ["left", "middle", "right"]}, {}],
            )
        )
        self.enterContext(patch.object(prj, "rex_window_width", return_value=300))
        self.enterContext(patch.object(prj, "direnv_allowed", return_value=allowed))
        run = self.enterContext(patch.object(prj, "run"))
        prj.rex_open_window("project", project, host)
        return api, run

    def blocks(self, layout):
        if "block" in layout:
            return [layout["block"]]
        return self.blocks(layout["split"]["before"]) + self.blocks(layout["split"]["after"])

    def test_local_project_has_three_columns_and_focused_editor(self):
        api, run = self.create_window()
        request = api.call_args_list[1]
        self.assertEqual(request.args[0], "session.new_window")
        layout = request.args[1]["layout"]
        self.assertEqual(request.args[1]["window_label"], "project")
        blocks = self.blocks(layout)
        self.assertEqual(len(blocks), 3)
        self.assertEqual([block["options"]["cwd"] for block in blocks], ["/src/project"] * 3)
        self.assertEqual([block["options"].get("initial_input") for block in blocks], [None, "vim .\n", None])
        self.assertAlmostEqual(layout["split"]["ratio"], 80 / 300)
        self.assertAlmostEqual(layout["split"]["after"]["split"]["ratio"], 140 / 220)
        self.assertEqual(api.call_args, call("session.focus_block", {"block_id": "middle"}))
        run.assert_not_called()

    def test_direnv_is_warmed_before_layout_creation(self):
        events = []
        with (
            patch.object(prj, "rex_api") as api,
            patch.object(prj, "rex_window_width", return_value=300),
            patch.object(prj, "direnv_allowed", return_value=True),
            patch.object(prj, "run", side_effect=lambda *a, **kw: events.append("warm")),
        ):

            def request(method, args=None):
                events.append(method)
                return {"windows": []} if method == "session.view" else {"block_ids": ["left", "middle", "right"]}

            api.side_effect = request
            prj.rex_open_window("project", "/src/my project")
        self.assertLess(events.index("warm"), events.index("session.new_window"))
        blocks = self.blocks(api.call_args_list[1].args[1]["layout"])
        self.assertEqual(blocks[1]["options"]["initial_input"], "direnv exec . vim .\n")

    def test_existing_window_is_reused_without_starting_processes(self):
        with (
            patch.object(
                prj,
                "rex_api",
                side_effect=[{"windows": [{"label": "project", "window_id": "existing"}]}, {}],
            ) as api,
            patch.object(prj, "direnv_allowed") as allowed,
        ):
            prj.rex_open_window("project", "/src/project")
        self.assertEqual(api.call_args, call("session.focus_window", {"window_id": "existing"}))
        allowed.assert_not_called()

    def test_remote_project_quotes_host_and_path_without_local_direnv(self):
        api, _ = self.create_window("/remote/it's a project", "host.example")
        prj.direnv_allowed.assert_not_called()
        blocks = self.blocks(api.call_args_list[1].args[1]["layout"])
        for index, block in enumerate(blocks):
            self.assertNotIn("cwd", block["options"])
            command = shlex.split(block["options"]["initial_input"].strip())
            self.assertEqual(command[:4], ["ssh", "-t", "--", "host.example"])
            self.assertIn(shlex.quote("/remote/it's a project"), command[4])
            self.assertEqual("vim ." in command[4], index == 1)

    def test_project_dispatches_to_rex(self):
        with patch.object(prj, "run"), patch.object(prj, "rex_open_window") as open_window:
            prj.open_project("/src/my-project")
            self.assertEqual(open_window.call_args, call("my-project", "/src/my-project"))
            prj.open_project("host.example:/src/my-project", remote=True)
            self.assertEqual(open_window.call_args, call("my-project@host", "/src/my-project", "host.example"))

    def test_ssh_dispatches_to_rex(self):
        with (
            patch.object(prj, "run", side_effect=["host", ""]),
            patch.object(prj, "rex_open_window") as open_window,
        ):
            prj.open_ssh()
        self.assertEqual(open_window.call_args, call("ssh@host", host="host"))

    def test_ssh_has_three_shells_and_no_editor(self):
        api, _ = self.create_window(project=None, host="host.example")
        blocks = self.blocks(api.call_args_list[1].args[1]["layout"])
        for block in blocks:
            self.assertEqual(shlex.split(block["options"]["initial_input"]), ["ssh", "--", "host.example"])

    def test_nested_tmux_takes_precedence(self):
        with (
            patch.object(prj, "is_tmux", True),
            patch.object(prj, "run", side_effect=["", "1,project", ""]) as run,
            patch.object(prj, "rex_open_window") as open_window,
        ):
            prj.open_project("/src/project")
        open_window.assert_not_called()
        self.assertEqual(run.call_args, call("tmux select-window -t project"))

    def test_nested_zellij_takes_precedence(self):
        with (
            patch.object(prj, "is_zellij", True),
            patch.object(prj, "run", side_effect=["", "project", ""]) as run,
            patch.object(prj, "rex_open_window") as open_window,
        ):
            prj.open_project("/src/project")
        open_window.assert_not_called()
        self.assertEqual(run.call_args, call("zellij action go-to-tab-name project"))

    def test_relayout_handles_both_horizontal_tree_shapes_and_skips_other_layouts(self):
        left, middle, right = leaf("left", 0, 0.25), leaf("middle", 0.25, 0.5), leaf("right", 0.75, 0.25)
        layouts = [
            split(left, split(middle, right)),
            split(split(left, middle), right),
            split(left, right),
            split(left, split(middle, right, direction="vertical")),
        ]
        with (
            patch.object(prj, "rex_api", return_value={}) as api,
            patch.object(prj, "rex_window_width", return_value=300),
            patch("builtins.print") as output,
        ):
            api.side_effect = [{"windows": [window(layout) for layout in layouts]}] + [{}] * 4
            prj.rex_relayout()
        resizes = [c.args[1] for c in api.call_args_list if c.args[0] == "session.resize_pane"]
        self.assertEqual(len(resizes), 4)
        self.assertAlmostEqual(resizes[0]["ratio"], 80 / 300)
        self.assertAlmostEqual(resizes[1]["ratio"], 140 / 220)
        self.assertAlmostEqual(resizes[2]["ratio"], 220 / 300)
        self.assertAlmostEqual(resizes[3]["ratio"], 80 / 220)
        output.assert_called_once_with("relayout: 2 sized, 2 skipped")


if __name__ == "__main__":
    unittest.main()
