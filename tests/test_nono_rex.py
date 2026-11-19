#!/usr/bin/env python3
import contextlib
import importlib.util
import io
import json
import os
import subprocess
import tempfile
import unittest
from importlib.machinery import SourceFileLoader
from pathlib import Path
from unittest.mock import Mock, patch

SCRIPT = Path(__file__).parents[1] / "bin" / "nono-rex"
LOADER = SourceFileLoader("nono_rex", str(SCRIPT))
SPEC = importlib.util.spec_from_loader(LOADER.name, LOADER)
assert SPEC is not None
nono_rex = importlib.util.module_from_spec(SPEC)
LOADER.exec_module(nono_rex)


class LauncherTest(unittest.TestCase):
    def setUp(self):
        self.root = Path(self.enterContext(tempfile.TemporaryDirectory())).resolve()
        self.home = self.root / "home"
        self.home.mkdir()
        self.enterContext(
            patch.dict(
                os.environ,
                {"HOME": str(self.home), "XDG_STATE_HOME": str(self.root / "state"), "NONO_REX_PROFILE": "testing"},
            )
        )
        self.enterContext(patch.object(nono_rex.shutil, "which", return_value="/tools/rex"))
        self.workspaces = self.root / "workspaces"

    def sandbox(self):
        return nono_rex.Sandbox()

    def test_default_and_passthrough_arguments(self):
        self.assertEqual(nono_rex.parse_args([], self.workspaces), ("open", None, Path.cwd(), []))
        for args in ([], ["--allow", "/tmp", "--workspace", "later"], ["-w", "--stop", "--list", "--remove", "--"]):
            with self.subTest(args=args):
                self.assertEqual(nono_rex.parse_args(["--", *args], self.workspaces), ("open", None, Path.cwd(), args))

    def test_nono_arguments_require_separator(self):
        for args in (
            ["--allow", "/tmp"],
            ["project"],
            ["-w", "--allow-cwd"],
            ["-w", "ABC-123", "--read", "/tmp"],
            ["--workspace", "ABC-123", "extra", "--", "--block-net"],
            ["--unknown", "--", "--read", "/tmp"],
            ["--stop", "--unknown"],
            ["-w", "-l"],
        ):
            with (
                self.subTest(args=args),
                self.assertRaises(SystemExit) as error,
                contextlib.redirect_stderr(io.StringIO()),
            ):
                nono_rex.parse_args(args, self.workspaces)
            self.assertEqual(error.exception.code, 2)

    def test_help_is_generated_by_argparse_without_launching(self):
        for flag in ("-h", "--help"):
            with self.subTest(flag=flag):
                output = io.StringIO()
                with (
                    patch.object(nono_rex.sys, "argv", ["nono-rex", "-w", "TICKET-123", flag]),
                    patch.object(nono_rex.subprocess, "run") as run,
                    patch.object(nono_rex.subprocess, "check_output") as check_output,
                    patch.object(nono_rex.os, "chdir") as chdir,
                    contextlib.redirect_stdout(output),
                    self.assertRaises(SystemExit) as error,
                ):
                    nono_rex.main()
                self.assertEqual(error.exception.code, 0)
                for option in ("-h, --help", "--workspace", "--list", "--stop", "--remove", "after --"):
                    self.assertIn(option, output.getvalue())
                run.assert_not_called()
                check_output.assert_not_called()
                chdir.assert_not_called()

    def test_help_after_separator_is_forwarded(self):
        for flag in ("-h", "--help"):
            with self.subTest(flag=flag):
                self.assertEqual(
                    nono_rex.parse_args(["--", flag], self.workspaces),
                    ("open", None, Path.cwd(), [flag]),
                )

    def test_workspace_optional_name_and_flags(self):
        for flag in ("-w", "--workspace"):
            for name in ("a", "9._-ok", "ABC-123"):
                with self.subTest(flag=flag, name=name):
                    self.assertEqual(
                        nono_rex.parse_args([flag, name, "--", "--read", "/tmp"], self.workspaces),
                        ("workspace", name, Path.cwd(), ["--read", "/tmp"]),
                    )
            self.assertEqual(nono_rex.parse_args([flag], self.workspaces), ("workspace", None, Path.cwd(), []))
            self.assertEqual(
                nono_rex.parse_args([flag, "--", "--allow-cwd"], self.workspaces),
                ("workspace", None, Path.cwd(), ["--allow-cwd"]),
            )

    def test_workspace_names_are_full_matches(self):
        for name in ("", ".hidden", "_hidden", "../escape", "a/b", "a b", "a\n", "é"):
            with (
                self.subTest(name=name),
                self.assertRaises(SystemExit) as error,
                contextlib.redirect_stderr(io.StringIO()),
            ):
                nono_rex.parse_args(["-w", name], self.workspaces)
            self.assertEqual(error.exception.code, 2)

    def test_list_and_stop_reject_extra_arguments(self):
        for flag in ("-l", "--list"):
            self.assertEqual(nono_rex.parse_args([flag], self.workspaces), ("list", None, Path.cwd(), []))
            with self.assertRaises(SystemExit) as error, contextlib.redirect_stderr(io.StringIO()):
                nono_rex.parse_args([flag, "extra"], self.workspaces)
            self.assertEqual(error.exception.code, 2)
        with self.assertRaises(SystemExit) as error, contextlib.redirect_stderr(io.StringIO()):
            nono_rex.parse_args(["--stop", "one", "two"], self.workspaces)
        self.assertEqual(error.exception.code, 2)
        for args in (
            ["--list", "--", "--block-net"],
            ["-l", "--", "--read", "/tmp"],
            ["--stop", "--", "--block-net"],
            ["--stop", "named", "--", "--block-net"],
        ):
            with (
                self.subTest(args=args),
                self.assertRaises(SystemExit) as error,
                contextlib.redirect_stderr(io.StringIO()),
            ):
                nono_rex.parse_args(args, self.workspaces)
            self.assertEqual(error.exception.code, 2)

    def test_stop_resolves_only_existing_bare_workspace_ids(self):
        workspace = self.workspaces / "named"
        workspace.mkdir(parents=True)
        for args, target in (
            (["--stop"], Path.cwd()),
            (["--stop", "named"], workspace),
            (["--stop", "missing"], Path("missing")),
            (["--stop", "./named"], Path("./named")),
            (["--stop", str(workspace)], workspace),
        ):
            with self.subTest(args=args):
                self.assertEqual(nono_rex.parse_args(args, self.workspaces), ("stop", None, target, []))

    def test_remove_resolves_existing_bare_workspace_ids(self):
        workspace = self.workspaces / "named"
        workspace.mkdir(parents=True)
        for flag in ("-r", "--remove"):
            for argument, target in (
                ("named", workspace),
                ("missing", Path("missing")),
                ("./named", Path("./named")),
                (str(workspace), workspace),
            ):
                with self.subTest(flag=flag, argument=argument):
                    self.assertEqual(
                        nono_rex.parse_args([flag, argument], self.workspaces),
                        ("remove", None, target, []),
                    )

    def test_remove_requires_target_and_rejects_extra_arguments_and_modes(self):
        for flag in ("-r", "--remove"):
            for args in (
                [flag],
                [flag, "--"],
                [flag, "named", "extra"],
                [flag, "named", "--read", "/tmp"],
                [flag, "named", "--", "--read", "/tmp"],
                [flag, "named", "--force"],
                [flag, "named", "--list"],
                [flag, "named", "--stop"],
                [flag, "named", "--workspace"],
                ["--list", flag, "named"],
                ["--stop", flag, "named"],
                ["--workspace", flag, "named"],
            ):
                with (
                    self.subTest(args=args),
                    self.assertRaises(SystemExit) as error,
                    contextlib.redirect_stderr(io.StringIO()),
                ):
                    nono_rex.parse_args(args, self.workspaces)
                self.assertEqual(error.exception.code, 2)

    def test_environment_paths_and_profile(self):
        sandbox = self.sandbox()
        self.assertEqual(sandbox.home, self.home)
        self.assertEqual(sandbox.rex, "/tools/rex")
        self.assertEqual(sandbox.rex_app, self.home / "Library/Application Support/com.superlogical.rex/RexServer")
        self.assertEqual(sandbox.rex_dir, self.root / "state/nono-rex")
        self.assertEqual(sandbox.workspaces_dir, self.root / "state/rex/workspaces")
        self.assertEqual(sandbox.profile, "testing")

    def test_default_environment_paths(self):
        with patch.dict(os.environ, {}, clear=True), patch.dict(os.environ, {"HOME": str(self.home)}):
            sandbox = self.sandbox()
        self.assertEqual(sandbox.rex_dir, self.home / ".local/state/nono-rex")
        self.assertEqual(sandbox.profile, "personal")

    def test_named_workspace_creation_preserves_cwd(self):
        cwd = Path.cwd()
        with (
            patch.object(nono_rex.subprocess, "check_output", return_value=str(self.root / "source") + "\n"),
            patch.object(nono_rex.subprocess, "run") as run,
        ):
            target = nono_rex.create_workspace(self.workspaces, "feature")
        self.assertEqual(target, self.workspaces / "feature")
        self.assertTrue(target.is_dir())
        self.assertEqual(Path.cwd(), cwd)
        self.assertEqual(list(run.call_args_list[-1].args[0]), ["jj", "workspace", "add", "--no-colocate", str(target)])

    def test_named_workspace_collision_is_not_reused(self):
        (self.workspaces / "feature").mkdir(parents=True)
        with (
            patch.object(nono_rex.subprocess, "check_output", return_value=str(self.root / "source") + "\n"),
            patch.object(nono_rex.subprocess, "run") as run,
            self.assertRaises(FileExistsError),
        ):
            nono_rex.create_workspace(self.workspaces, "feature")
        run.assert_not_called()

    def test_anonymous_workspaces_are_unique(self):
        with (
            patch.object(nono_rex.subprocess, "check_output", return_value=str(self.root / "source") + "\n"),
            patch.object(nono_rex.subprocess, "run"),
        ):
            first = nono_rex.create_workspace(self.workspaces, None)
            second = nono_rex.create_workspace(self.workspaces, None)
        self.assertNotEqual(first, second)
        for target in (first, second):
            self.assertEqual(target.parent, self.workspaces)
            self.assertTrue(target.name.startswith("source."))
            self.assertTrue(target.is_dir())

    def test_metadata_grants_relative_and_absolute_shared_repo(self):
        workspace = self.root / "checkout"
        (workspace / ".jj").mkdir(parents=True)
        repo = self.root / "shared/repo"
        repo.mkdir(parents=True)
        git = self.root / "git"
        for pointer in (str(repo), "../../shared/repo"):
            with self.subTest(pointer=pointer):
                (workspace / ".jj/repo").write_text(pointer + "\n")
                with patch.object(
                    nono_rex.subprocess,
                    "run",
                    side_effect=[
                        subprocess.CompletedProcess([], 0, str(workspace) + "\n", ""),
                        subprocess.CompletedProcess([], 0, str(git) + "\n", ""),
                    ],
                ):
                    self.assertEqual(
                        nono_rex.metadata_grants(),
                        ["--allow", str(workspace), "--allow", str(repo), "--allow", str(git)],
                    )

    def test_primary_checkout_needs_no_extra_grants(self):
        (self.root / ".jj/repo").mkdir(parents=True)
        with patch.object(
            nono_rex.subprocess, "run", return_value=subprocess.CompletedProcess([], 0, str(self.root) + "\n", "")
        ):
            self.assertEqual(nono_rex.metadata_grants(), [])

    def test_non_jj_directory_needs_no_extra_grants(self):
        with patch.object(nono_rex.subprocess, "run", return_value=subprocess.CompletedProcess([], 1, "", "")):
            self.assertEqual(nono_rex.metadata_grants(), [])

    def test_slot_for_ignores_stopped_and_unrelated_servers(self):
        sandbox = self.sandbox()
        for label, target in (("sandbox-1", self.root), ("sandbox-2", self.root), ("sandbox-3", self.home)):
            directory = sandbox.rex_dir / label
            directory.mkdir(parents=True)
            (directory / "cwd").write_text(str(target) + "\n")
        with patch.object(sandbox, "running", side_effect=lambda label: label != "sandbox-1"):
            self.assertEqual(sandbox.slot_for(self.root), "sandbox-2")
            self.assertIsNone(sandbox.slot_for(self.root / "missing"))

    def test_listing_includes_only_jj_workspaces(self):
        sandbox = self.sandbox()
        for name in ("alpha", "beta"):
            (sandbox.workspaces_dir / name / ".jj").mkdir(parents=True)
        (sandbox.workspaces_dir / "ordinary").mkdir()
        output = io.StringIO()
        with (
            patch.object(
                sandbox, "slot_for", side_effect=lambda target: "sandbox-2" if target.name == "alpha" else None
            ),
            contextlib.redirect_stdout(output),
        ):
            sandbox.list_workspaces()
        self.assertEqual(
            output.getvalue().splitlines(),
            [
                "ID\tSTATUS\tHOST\tPATH",
                f"alpha\trunning\tsandbox-2\t{sandbox.workspaces_dir / 'alpha'}",
                f"beta\tstopped\t-\t{sandbox.workspaces_dir / 'beta'}",
            ],
        )

    def test_listing_empty_directory_prints_header(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            self.sandbox().list_workspaces()
        self.assertEqual(output.getvalue(), "ID\tSTATUS\tHOST\tPATH\n")

    def test_choose_slot_reuses_matching_server_except_for_new_workspace(self):
        sandbox = self.sandbox()
        directory = sandbox.rex_dir / "sandbox-2"
        directory.mkdir(parents=True)
        (directory / "cwd").write_text(str(self.root) + "\n")
        hosts = json.dumps({"hosts": [{"label": "sandbox-1"}, {"label": "sandbox-2"}, {"label": "unrelated"}]})
        with (
            patch.object(nono_rex.subprocess, "check_output", return_value=hosts),
            patch.object(sandbox, "running", side_effect=lambda label: label == "sandbox-2"),
        ):
            self.assertEqual(sandbox.choose_slot(self.root), ("sandbox-2", "sandbox-1"))
            self.assertEqual(sandbox.choose_slot(self.root, new_workspace=True), (None, "sandbox-1"))

    def test_running_checks_explicit_socket_without_autostart(self):
        sandbox = self.sandbox()
        for status in (0, 1):
            with (
                self.subTest(status=status),
                patch.object(nono_rex.subprocess, "run", return_value=subprocess.CompletedProcess([], status)) as run,
            ):
                self.assertEqual(sandbox.running("sandbox-1"), status == 0)
            self.assertEqual(
                run.call_args.args[0],
                [
                    sandbox.rex,
                    "--server",
                    f"unix://{sandbox.rex_dir / 'sandbox-1.sock'}",
                    "--autostart=false",
                    "whoami",
                ],
            )

    def test_missing_jj_executable_needs_no_grants(self):
        with patch.object(nono_rex.subprocess, "run", side_effect=FileNotFoundError):
            self.assertEqual(nono_rex.metadata_grants(), [])

    def test_shared_repo_without_git_still_has_metadata_grants(self):
        workspace = self.root / "checkout"
        (workspace / ".jj").mkdir(parents=True)
        repo = self.root / "repo"
        repo.mkdir()
        (workspace / ".jj/repo").write_text(str(repo))
        with patch.object(
            nono_rex.subprocess,
            "run",
            side_effect=[
                subprocess.CompletedProcess([], 0, str(workspace), ""),
                subprocess.CompletedProcess([], 1, "", ""),
            ],
        ):
            self.assertEqual(nono_rex.metadata_grants(), ["--allow", str(workspace), "--allow", str(repo)])

    def test_choose_slot_returns_none_when_all_sandbox_hosts_are_busy(self):
        sandbox = self.sandbox()
        with (
            patch.object(
                nono_rex.subprocess,
                "check_output",
                return_value='[{"label":"sandbox-1"},{"label":"sandbox-2"},{"label":"other"}]',
            ),
            patch.object(sandbox, "running", return_value=True),
        ):
            self.assertEqual(sandbox.choose_slot(self.root), (None, None))

    def test_main_reuses_running_server_without_starting(self):
        sandbox = self.sandbox()
        with (
            patch.object(nono_rex, "Sandbox", return_value=sandbox),
            patch.object(nono_rex.sys, "argv", ["nono-rex"]),
            patch.object(nono_rex.os, "chdir"),
            patch.object(sandbox, "choose_slot", return_value=("sandbox-1", None)),
            patch.object(sandbox, "start") as start,
            patch.object(sandbox, "open_session", return_value=0),
        ):
            self.assertEqual(nono_rex.main(), 0)
        start.assert_not_called()

    def test_main_does_not_open_session_after_start_failure(self):
        sandbox = self.sandbox()
        with (
            patch.object(nono_rex, "Sandbox", return_value=sandbox),
            patch.object(nono_rex.sys, "argv", ["nono-rex"]),
            patch.object(nono_rex.os, "chdir"),
            patch.object(sandbox, "choose_slot", return_value=(None, "sandbox-1")),
            patch.object(sandbox, "start", return_value=False),
            patch.object(sandbox, "open_session") as open_session,
        ):
            self.assertEqual(nono_rex.main(), 1)
        open_session.assert_not_called()

    def test_start_detaches_server_and_login_shells_and_publishes_socket(self):
        sandbox = self.sandbox()
        with (
            patch.object(nono_rex, "metadata_grants", return_value=["--allow", "/shared"]),
            patch.object(Path, "is_socket", return_value=True),
            patch.object(nono_rex.subprocess, "Popen") as popen,
            contextlib.redirect_stderr(io.StringIO()),
        ):
            self.assertTrue(sandbox.start("sandbox-1", ["--read", "/extra space"]))
        self.assertEqual(popen.call_count, 2)
        server, login = popen.call_args_list
        directory = sandbox.rex_dir / "sandbox-1"
        self.assertEqual(
            server.args[0],
            [
                "nono",
                "run",
                "--verbose",
                "--profile",
                "testing",
                "--allow-cwd",
                "--read",
                "/extra space",
                "--allow",
                "/shared",
                "--read",
                str(sandbox.rex_app),
                "--allow",
                str(directory),
                "--allow-unix-socket-dir-bind",
                str(directory / "run"),
                "--",
                sandbox.rex,
                "server",
                "run",
                "--state-dir",
                str(directory / "state"),
            ],
        )
        for invocation in (server, login):
            self.assertTrue(invocation.kwargs["start_new_session"])
            self.assertEqual(invocation.kwargs["stdin"], subprocess.DEVNULL)
            self.assertEqual(invocation.kwargs["stderr"], subprocess.STDOUT)
        self.assertEqual(server.kwargs["env"]["REX_RUNTIME_DIR"], str(directory / "run"))
        self.assertEqual(server.kwargs["env"]["REX_HOME"], str(directory / "home"))
        self.assertEqual((sandbox.rex_dir / "sandbox-1.sock").readlink(), directory / "run/server.sock")
        self.assertEqual((directory / "cwd").read_text(), str(Path.cwd()) + "\n")
        self.assertEqual(login.args[0][-1], f"cwd={Path.cwd()}")
        self.assertIn(str(self.home / ".dotfiles/apps/rex/nono-login-shells.lua"), login.args[0])

    def test_start_prints_failed_server_log_without_publishing_socket(self):
        sandbox = self.sandbox()

        def failed_server(*args, **kwargs):
            kwargs["stdout"].write("sandbox denied permission\n")
            kwargs["stdout"].flush()
            return Mock(poll=Mock(return_value=1))

        output = io.StringIO()
        with (
            patch.object(nono_rex, "metadata_grants", return_value=[]),
            patch.object(Path, "is_socket", return_value=False),
            patch.object(nono_rex.subprocess, "Popen", side_effect=failed_server) as popen,
            contextlib.redirect_stderr(output),
        ):
            self.assertFalse(sandbox.start("sandbox-1", []))
        self.assertEqual(popen.call_count, 1)
        self.assertIn("sandbox denied permission", output.getvalue())
        self.assertFalse((sandbox.rex_dir / "sandbox-1.sock").is_symlink())

    def test_open_session_escapes_json_and_applescript(self):
        sandbox = self.sandbox()
        cwd = self.root / 'project "quoted"\\slash'
        with (
            patch.object(Path, "cwd", return_value=cwd),
            patch.object(
                nono_rex.subprocess,
                "run",
                side_effect=[
                    subprocess.CompletedProcess([], 1),
                    subprocess.CompletedProcess([], 0),
                    subprocess.CompletedProcess([], 0),
                ],
            ) as run,
        ):
            self.assertEqual(sandbox.open_session("sandbox-1"), 0)
        creation = run.call_args_list[1].args[0]
        self.assertEqual(creation[-2], "session.create")
        payload = json.loads(creation[-1])
        self.assertEqual(payload["label"], cwd.name)
        options = payload["initial_windows"][0]["layout"]["block"]["options"]
        self.assertEqual(options, {"login": False, "cwd": str(cwd)})
        self.assertIn(json.dumps(cwd.name), run.call_args_list[-1].args[0][-1])

    def test_open_session_reuses_existing_and_retries_thirty_times(self):
        sandbox = self.sandbox()
        output = io.StringIO()
        with (
            patch.object(
                nono_rex.subprocess,
                "run",
                side_effect=[subprocess.CompletedProcess([], 0)] + [subprocess.CompletedProcess([], 1)] * 30,
            ) as run,
            patch.object(nono_rex.time, "sleep"),
            contextlib.redirect_stderr(output),
        ):
            self.assertEqual(sandbox.open_session("sandbox-1"), 1)
        self.assertEqual(run.call_count, 31)
        self.assertTrue(all(invocation.args[0][0] == "osascript" for invocation in run.call_args_list[1:]))
        self.assertIn("Switch Host", output.getvalue())

    def test_main_lists_without_slot_selection(self):
        sandbox = Mock()
        with (
            patch.object(nono_rex, "Sandbox", return_value=sandbox),
            patch.object(nono_rex.sys, "argv", ["nono-rex", "--list"]),
        ):
            self.assertEqual(nono_rex.main(), 0)
        sandbox.list_workspaces.assert_called_once_with()
        sandbox.choose_slot.assert_not_called()

    def test_main_checks_slot_before_creating_workspace(self):
        sandbox = self.sandbox()
        with (
            patch.object(nono_rex, "Sandbox", return_value=sandbox),
            patch.object(nono_rex.sys, "argv", ["nono-rex", "-w", "feature"]),
            patch.object(sandbox, "choose_slot", return_value=(None, None)),
            patch.object(nono_rex, "create_workspace") as create,
            patch.object(nono_rex.os, "chdir"),
            contextlib.redirect_stderr(io.StringIO()),
        ):
            self.assertEqual(nono_rex.main(), 1)
        create.assert_not_called()

    def test_main_creates_workspace_then_starts_and_opens(self):
        sandbox = self.sandbox()
        target = self.root / "new"
        events = []
        with (
            patch.object(nono_rex, "Sandbox", return_value=sandbox),
            patch.object(nono_rex.sys, "argv", ["nono-rex", "-w", "feature", "--", "--read", "/extra"]),
            patch.object(
                sandbox, "choose_slot", side_effect=lambda *a, **kw: events.append("choose") or (None, "sandbox-1")
            ),
            patch.object(nono_rex, "create_workspace", side_effect=lambda *a: events.append("create") or target),
            patch.object(nono_rex.os, "chdir") as chdir,
            patch.object(sandbox, "start", side_effect=lambda *a: events.append("start") or True) as start,
            patch.object(sandbox, "open_session", return_value=0) as open_session,
        ):
            self.assertEqual(nono_rex.main(), 0)
        self.assertEqual(events, ["choose", "create", "start"])
        self.assertEqual(chdir.call_args.args, (target,))
        start.assert_called_once_with("sandbox-1", ["--read", "/extra"])
        open_session.assert_called_once_with("sandbox-1")

    def test_main_stop_delegates_to_sandbox(self):
        sandbox = self.sandbox()
        with (
            patch.object(nono_rex, "Sandbox", return_value=sandbox),
            patch.object(nono_rex.sys, "argv", ["nono-rex", "--stop"]),
            patch.object(nono_rex.os, "chdir"),
            patch.object(sandbox, "slot_for", return_value="sandbox-2"),
            patch.object(sandbox, "stop") as stop,
        ):
            self.assertEqual(nono_rex.main(), 0)
        stop.assert_called_once_with("sandbox-2")

    def test_stop_closes_sessions_before_stopping_server(self):
        sandbox = self.sandbox()
        slot = "sandbox-2"
        command = [sandbox.rex, "--server", f"unix://{sandbox.rex_dir / slot}.sock", "--autostart=false"]
        for sessions in ([], ["first-id", "second-id"]):
            with (
                self.subTest(sessions=sessions),
                patch.object(nono_rex.subprocess, "check_output", return_value="\n".join(sessions)) as output,
                patch.object(nono_rex.subprocess, "run") as run,
            ):
                sandbox.stop(slot)
            output.assert_called_once_with([*command, "session", "ls", "--quiet", "--short=false"], text=True)
            self.assertEqual(run.call_count, 2 if sessions else 1)
            if sessions:
                self.assertEqual(run.call_args_list[0].args, ([*command, "session", "kill", *sessions],))
                self.assertTrue(run.call_args_list[0].kwargs["check"])
            self.assertEqual(run.call_args.args, ([sandbox.rex, "server", "stop"],))
            self.assertEqual(run.call_args.kwargs["env"]["REX_RUNTIME_DIR"], str(sandbox.rex_dir / slot / "run"))
            self.assertTrue(run.call_args.kwargs["check"])

    def test_stop_leaves_server_running_on_session_teardown_failure(self):
        sandbox = self.sandbox()
        error = subprocess.CalledProcessError(1, ["session", "kill"])
        with (
            patch.object(nono_rex.subprocess, "check_output", return_value="session-id\n"),
            patch.object(nono_rex.subprocess, "run", side_effect=error) as run,
            self.assertRaises(subprocess.CalledProcessError),
        ):
            sandbox.stop("sandbox-2")
        self.assertEqual(run.call_count, 1)
        self.assertEqual(run.call_args.args[0][-3:], ["session", "kill", "session-id"])

    def test_main_stop_reports_missing_server(self):
        sandbox = self.sandbox()
        output = io.StringIO()
        with (
            patch.object(nono_rex, "Sandbox", return_value=sandbox),
            patch.object(nono_rex.sys, "argv", ["nono-rex", "--stop"]),
            patch.object(nono_rex.os, "chdir"),
            patch.object(sandbox, "slot_for", return_value=None),
            patch.object(sandbox, "stop") as stop,
            contextlib.redirect_stderr(output),
        ):
            self.assertEqual(nono_rex.main(), 1)
        stop.assert_not_called()
        self.assertIn("No sandbox is running", output.getvalue())

    def secondary_workspace(self, sandbox, name="removable"):
        target = sandbox.workspaces_dir / name
        (target / ".jj").mkdir(parents=True)
        (target / ".jj/repo").write_text("/shared/repo\n")
        return target

    def test_remove_deletes_ignored_files_and_symlinks_in_safe_order(self):
        for slot in (None, "sandbox-2"):
            with self.subTest(slot=slot):
                sandbox = self.sandbox()
                target = self.secondary_workspace(sandbox)
                (target / "nested").mkdir()
                (target / "nested/ignored\nfile").write_text("ignored")
                (target / "untracked").write_text("untracked")
                (target / "untracked-link").symlink_to(self.home, target_is_directory=True)
                (target / "broken-link").symlink_to(self.root / "missing")
                (self.home / "not-in-workspace").write_text("preserve the symlink target")
                events = []
                real_rmtree = nono_rex.shutil.rmtree

                def stop_server(selected_slot, *, slot=slot, events=events):
                    events.append("stop")
                    self.assertEqual(selected_slot, slot)

                def run(command, *, events=events, target=target, **kwargs):
                    events.append("forget")
                    self.assertEqual(command, ["jj", "--repository", str(target), "workspace", "forget"])
                    self.assertEqual(kwargs["cwd"], target)
                    self.assertTrue(kwargs["check"])
                    self.assertTrue(target.is_dir())
                    return subprocess.CompletedProcess(command, 0)

                def check_output(command, *, target=target, events=events, **kwargs):
                    self.assertTrue(target.is_dir())
                    events.append("check")
                    self.assertEqual(
                        command,
                        [
                            "jj",
                            "--repository",
                            str(target),
                            "log",
                            "--no-graph",
                            "--revision",
                            "@",
                            "--template",
                            'empty && description == ""',
                        ],
                    )
                    self.assertTrue(kwargs["text"])
                    self.assertEqual(kwargs["cwd"], target)
                    return "true\n"

                def chdir(directory, *, events=events, sandbox=sandbox, target=target):
                    events.append("chdir")
                    self.assertEqual(directory, sandbox.workspaces_dir)
                    self.assertTrue(target.is_dir())

                def remove_tree(directory, *, events=events, target=target, real_rmtree=real_rmtree):
                    events.append("delete")
                    self.assertEqual(directory, target)
                    real_rmtree(directory)

                output = io.StringIO()
                with (
                    patch.object(sandbox, "slot_for", return_value=slot) as slot_for,
                    patch.object(sandbox, "stop", side_effect=stop_server),
                    patch.object(nono_rex.subprocess, "run", side_effect=run),
                    patch.object(nono_rex.subprocess, "check_output", side_effect=check_output),
                    patch.object(nono_rex.os, "chdir", side_effect=chdir),
                    patch.object(nono_rex.shutil, "rmtree", side_effect=remove_tree),
                    contextlib.redirect_stdout(output),
                ):
                    self.assertEqual(sandbox.remove(target), 0)
                slot_for.assert_called_once_with(target.resolve())
                self.assertEqual(events, (["stop"] if slot else []) + ["check", "forget", "chdir", "delete"])
                self.assertFalse(target.exists())
                self.assertTrue((self.home / "not-in-workspace").is_file())
                self.assertIn(target.name, output.getvalue())

    def test_remove_refuses_unsafe_workspace_locations_and_primary_repositories(self):
        sandbox = self.sandbox()
        outside = self.root / "outside"
        (outside / ".jj").mkdir(parents=True)
        (outside / ".jj/repo").write_text("/shared/repo\n")
        primary = sandbox.workspaces_dir / "primary"
        (primary / ".jj/repo").mkdir(parents=True)
        nested = self.secondary_workspace(sandbox, "parent/nested")
        ordinary = sandbox.workspaces_dir / "ordinary"
        ordinary.mkdir()
        escaped = sandbox.workspaces_dir / "escape"
        escaped.symlink_to(outside, target_is_directory=True)
        for target in (outside, primary, nested, ordinary, escaped, sandbox.workspaces_dir):
            with (
                self.subTest(target=target),
                patch.object(sandbox, "slot_for") as slot_for,
                patch.object(nono_rex.subprocess, "run") as run,
                patch.object(nono_rex.subprocess, "check_output") as check_output,
                patch.object(nono_rex.shutil, "rmtree") as rmtree,
                patch.object(nono_rex.os, "chdir") as chdir,
                self.assertRaises(ValueError),
            ):
                sandbox.remove(target)
            slot_for.assert_not_called()
            run.assert_not_called()
            check_output.assert_not_called()
            rmtree.assert_not_called()
            chdir.assert_not_called()
            self.assertTrue(target.exists())

    def test_remove_requires_existing_target(self):
        sandbox = self.sandbox()
        with (
            patch.object(nono_rex.subprocess, "run") as run,
            patch.object(nono_rex.subprocess, "check_output") as check_output,
            patch.object(nono_rex.shutil, "rmtree") as rmtree,
            self.assertRaises(FileNotFoundError),
        ):
            sandbox.remove(sandbox.workspaces_dir / "missing")
        run.assert_not_called()
        check_output.assert_not_called()
        rmtree.assert_not_called()

    def test_remove_refuses_nonempty_or_described_working_copy(self):
        sandbox = self.sandbox()
        target = self.secondary_workspace(sandbox)
        for reason in ("nonempty working copy", "described empty working copy"):
            with (
                self.subTest(reason=reason),
                patch.object(sandbox, "slot_for", return_value=None),
                patch.object(nono_rex.subprocess, "run") as run,
                patch.object(nono_rex.subprocess, "check_output", return_value="false\n") as check_output,
                patch.object(nono_rex.shutil, "rmtree") as rmtree,
                patch.object(nono_rex.os, "chdir") as chdir,
                self.assertRaises(ValueError),
            ):
                sandbox.remove(target)
            self.assertEqual(check_output.call_count, 1)
            run.assert_not_called()
            rmtree.assert_not_called()
            chdir.assert_not_called()
            self.assertTrue(target.is_dir())

    def test_remove_subprocess_failures_prevent_later_steps(self):
        for failure in ("stop", "log", "forget"):
            with self.subTest(failure=failure):
                sandbox = self.sandbox()
                target = self.secondary_workspace(sandbox, failure)
                error = subprocess.CalledProcessError(1, [failure])
                outputs = {
                    "stop": [],
                    "log": [error],
                    "forget": ["true\n"],
                }
                with (
                    patch.object(sandbox, "slot_for", return_value="sandbox-2"),
                    patch.object(sandbox, "stop", side_effect=error if failure == "stop" else None),
                    patch.object(nono_rex.subprocess, "run", side_effect=error) as run,
                    patch.object(nono_rex.subprocess, "check_output", side_effect=outputs[failure]) as check_output,
                    patch.object(nono_rex.shutil, "rmtree") as rmtree,
                    patch.object(nono_rex.os, "chdir") as chdir,
                    self.assertRaises(subprocess.CalledProcessError) as raised,
                ):
                    sandbox.remove(target)
                self.assertIs(raised.exception, error)
                self.assertEqual(run.call_count, int(failure == "forget"))
                self.assertEqual(check_output.call_count, len(outputs[failure]))
                rmtree.assert_not_called()
                chdir.assert_not_called()
                self.assertTrue(target.is_dir())

    def test_main_removes_before_chdir_without_selecting_a_host(self):
        sandbox = self.sandbox()
        target = self.secondary_workspace(sandbox)
        with (
            patch.object(nono_rex, "Sandbox", return_value=sandbox),
            patch.object(nono_rex.sys, "argv", ["nono-rex", "--remove", target.name]),
            patch.object(sandbox, "remove", return_value=7) as remove,
            patch.object(sandbox, "choose_slot") as choose_slot,
            patch.object(sandbox, "start") as start,
            patch.object(sandbox, "open_session") as open_session,
            patch.object(nono_rex.os, "chdir") as chdir,
        ):
            self.assertEqual(nono_rex.main(), 7)
        remove.assert_called_once_with(target)
        choose_slot.assert_not_called()
        start.assert_not_called()
        open_session.assert_not_called()
        chdir.assert_not_called()


if __name__ == "__main__":
    unittest.main()
