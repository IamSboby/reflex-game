#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == "Darwin" ]] || { echo "This installer is for macOS." >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "Install Python 3 first." >&2; exit 1; }
SRC="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/Applications/ReflexGame"
PLIST="$HOME/Library/LaunchAgents/com.reflexgame.local.plist"
mkdir -p "$DEST/public" "$(dirname "$PLIST")"
cp "$SRC/server.py" "$DEST/server.py"
cp "$SRC"/{index.html,app.js,styles.css,effects.css,mobile.css,countdown.css,fixes.css,error-feedback.css,slider-effects.css} "$DEST/public/"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>Label</key><string>com.reflexgame.local</string><key>ProgramArguments</key><array><string>/usr/bin/env</string><string>python3</string><string>$DEST/server.py</string></array><key>EnvironmentVariables</key><dict><key>REFLEX_PORT</key><string>8080</string><key>REFLEX_ROOT</key><string>$DEST/public</string></dict><key>RunAtLoad</key><true/><key>KeepAlive</key><true/><key>StandardOutPath</key><string>$DEST/server.log</string><key>StandardErrorPath</key><string>$DEST/server-error.log</string></dict></plist>
EOF
launchctl unload "$PLIST" 2>/dev/null || true
launchctl load "$PLIST"
echo "Reflex Game is available at http://localhost:8080/"
