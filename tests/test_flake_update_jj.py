#!/usr/bin/env python3
import importlib.util
import unittest
from importlib.machinery import SourceFileLoader
from pathlib import Path

SCRIPT = Path(__file__).parents[1] / "bin" / "flake-update-jj"
LOADER = SourceFileLoader("flake_update_jj", str(SCRIPT))
SPEC = importlib.util.spec_from_loader(LOADER.name, LOADER)
assert SPEC is not None
flake_update_jj = importlib.util.module_from_spec(SPEC)
LOADER.exec_module(flake_update_jj)


def lock(mainstereo_crane: str, sower_crane: str, cranes: dict[str, str]):
    return {
        "root": "root",
        "nodes": {
            "root": {"inputs": {"mainstereo": "mainstereo", "sower": "sower"}},
            "mainstereo": {"inputs": {"crane": mainstereo_crane}},
            "sower": {"inputs": {"crane": sower_crane}},
            **{name: {"locked": {"rev": revision, "lastModified": 0}} for name, revision in cranes.items()},
        },
    }


class ChangedInputsTest(unittest.TestCase):
    def test_ignores_node_renumbering(self):
        old_lock = lock(
            "crane_3",
            "crane_4",
            {"crane_3": "692f7e9", "crane_4": "eb35abd"},
        )
        new_lock = lock(
            "crane_4",
            "crane_5",
            {
                "crane_3": "692f7e9",
                "crane_4": "692f7e9",
                "crane_5": "eb35abd",
            },
        )

        self.assertEqual(flake_update_jj.get_changed_inputs(old_lock, new_lock), [])

    def test_reports_change_after_node_renumbering(self):
        old_lock = lock(
            "crane_3",
            "crane_4",
            {"crane_3": "692f7e9", "crane_4": "eb35abd"},
        )
        new_lock = lock(
            "crane_4",
            "crane_5",
            {
                "crane_3": "692f7e9",
                "crane_4": "eb35abd",
                "crane_5": "eb35abd",
            },
        )

        self.assertEqual(
            flake_update_jj.get_changed_inputs(old_lock, new_lock),
            [("mainstereo/crane", "692f7e9", "eb35abd", "unknown", "unknown")],
        )


if __name__ == "__main__":
    unittest.main()
