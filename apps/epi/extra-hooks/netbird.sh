#!/usr/bin/env bash

"$EPI_BIN" cp /run/agenix/epi-netbird-env "$EPI_INSTANCE:/tmp/netbird.env"
"$EPI_BIN" cp /run/agenix/epi-netbird-setup-key "$EPI_INSTANCE:/tmp/setup-key"

"$EPI_BIN" exec "$EPI_INSTANCE" -- sudo mv /tmp/netbird.env /var/lib/netbird-vrob0/env
"$EPI_BIN" exec "$EPI_INSTANCE" -- sudo mv /tmp/setup-key /var/lib/netbird-vrob0/setup-key
"$EPI_BIN" exec "$EPI_INSTANCE" -- sudo chown root:root /var/lib/netbird-vrob0/env /var/lib/netbird-vrob0/setup-key
"$EPI_BIN" exec "$EPI_INSTANCE" -- sudo chmod 0444 /var/lib/netbird-vrob0/env /var/lib/netbird-vrob0/setup-key
"$EPI_BIN" exec "$EPI_INSTANCE" -- sudo systemctl restart --no-block netbird-vrob0-login
