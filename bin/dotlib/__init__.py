import os
import shlex
import subprocess
import sys


def run(command: str, capture_output: bool = True) -> str | None:
    run_command = shlex.split(command)

    result = subprocess.run(run_command, capture_output=capture_output, encoding="UTF-8")

    if result.returncode != 0:
        if capture_output and result.stderr is not None:
            print(result.stderr)
        print(f"Failed to run [{command}]")
        sys.exit(1)

    if capture_output:
        return result.stdout.strip()

    return None


def find_git_up(chdir: bool = True):
    dir = os.path.abspath(os.path.curdir)

    while not os.path.exists(os.path.join(dir, ".git")):
        if dir == os.getenv("HOME"):
            print("Could not find git root in home directory")
            sys.exit(1)

        dir = os.path.dirname(dir)

    if chdir:
        os.chdir(dir)

    return dir
