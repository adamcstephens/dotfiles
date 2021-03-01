#!/usr/bin/env python

import re
import subprocess

rfkill = subprocess.run("rfkill", check=True, capture_output=True)

for line in rfkill.stdout.decode("utf-8").strip().splitlines():
    line = line.split()

    if line[2] == "tpacpi_bluetooth_sw":
        if line[3] == "blocked":
            toggle = "unblock"
        elif line[3] == "unblocked":
            toggle = "block"

        rfkill_toggle = subprocess.run(
            ["rfkill", toggle, line[0]], check=True, capture_output=True
        )
        print(rfkill_toggle)
