#!/bin/bash
set -e

CONFIG_DIR="/var/rpi-config"
CONFIG_FILE="$CONFIG_DIR/local.config"
WEB_CONFIG="/var/www/html/local.config"

# Ensure the persistent config directory exists
mkdir -p "$CONFIG_DIR"

# Seed config file if it doesn't exist yet (first run)
if [ ! -f "$CONFIG_FILE" ]; then
    printf '<?php\nreturn array();\n?>\n' > "$CONFIG_FILE"
fi

# Fix ownership so www-data (Apache) can read/write it
chown www-data:www-data "$CONFIG_FILE"
chmod 664 "$CONFIG_FILE"

# Symlink the persistent config into the web root
ln -sf "$CONFIG_FILE" "$WEB_CONFIG"

exec apache2-foreground
