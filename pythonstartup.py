from rich import pretty
import json
import os
import subprocess
import sys


def run(command):
    return subprocess.run(command.split(' '), capture_output=True).stdout.decode('utf-8')

pretty.install()
