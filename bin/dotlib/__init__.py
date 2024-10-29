import subprocess, sys


def run(command: str, capture_output: bool = True) -> str | None:
    result = subprocess.run(command, shell=True, capture_output=capture_output)

    if result.returncode != 0:
        print(result.stderr.decode())
        print(f"Failed to run [{command}]")
        sys.exit(1)

    if capture_output:
        return result.stdout.decode().strip()

    return None
