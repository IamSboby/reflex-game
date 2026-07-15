#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This installer is for Linux. See README.md for macOS and Windows." >&2
  exit 1
fi

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/opt/reflex-game"
SERVICE_FILE="/etc/systemd/system/reflex-game.service"
SUDO=""
if [[ ${EUID} -ne 0 ]]; then SUDO="sudo"; fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is required; attempting installation..."
  if command -v apt-get >/dev/null 2>&1; then $SUDO apt-get update && $SUDO apt-get install -y python3
  elif command -v dnf >/dev/null 2>&1; then $SUDO dnf install -y python3
  elif command -v pacman >/dev/null 2>&1; then $SUDO pacman -Sy --noconfirm python
  else echo "Install Python 3, then run this installer again." >&2; exit 1; fi
fi

command -v systemctl >/dev/null 2>&1 || { echo "systemd is required for automatic startup." >&2; exit 1; }
if ! id reflex-web >/dev/null 2>&1; then
  $SUDO useradd --system --home /nonexistent --shell /usr/sbin/nologin reflex-web
fi

$SUDO install -d -o root -g root -m 0755 "$INSTALL_DIR" "$INSTALL_DIR/public"
$SUDO install -o root -g root -m 0755 "$ROOT_DIR/server.py" "$INSTALL_DIR/server.py"
for file in index.html app.js styles.css effects.css mobile.css countdown.css fixes.css error-feedback.css slider-effects.css; do
  $SUDO install -o root -g root -m 0644 "$ROOT_DIR/$file" "$INSTALL_DIR/public/$file"
done

tmp_service="$(mktemp)"
trap 'rm -f "$tmp_service"' EXIT
sed 's|/opt/reflex-arrows|/opt/reflex-game|g; s|reflex-arrows/public|reflex-game/public|g; s|Juego web local Reflejos|Reflex Game local web app|g' "$ROOT_DIR/reflex-arrows.service" > "$tmp_service"
$SUDO install -o root -g root -m 0644 "$tmp_service" "$SERVICE_FILE"
$SUDO systemctl daemon-reload
$SUDO systemctl enable --now reflex-game

IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
echo "Reflex Game is running."
echo "Open: http://${IP:-localhost}/"
echo "Status: sudo systemctl status reflex-game"
