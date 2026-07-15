# Reflex Game

Reflex Game is a small, offline-friendly reaction game for keyboard and touch. A direction appears on screen; respond with the matching arrow key or swipe. The game records reaction times, mistakes, accuracy, per-direction performance, and a lightweight progress chart.

The interface is intentionally simple: no framework, no CDN, no analytics, no accounts, and no external runtime dependencies in the browser. Settings stay in `localStorage`; game history for the current browser session stays in `sessionStorage`.

## Play online

The GitHub Pages address is shown in the repository description after deployment.

## What is included

- Four configurable directions and colors.
- Keyboard and continuous touch gestures.
- Accurate timing with `performance.now()`.
- Configurable game length from 10 seconds to 5 minutes.
- Optional darker arrow tint, soft synthesized sounds, volume control, and enhanced motion.
- Correct/incorrect feedback, animated color transitions, and reduced-motion support.
- Average, median, best and worst reaction times, accuracy, RPM, direction breakdown, and chart.
- No personal data transmission.

## Quick installation on Linux

Clone or download and extract the repository, then run:

```bash
chmod +x install.sh
sudo ./install.sh
```

The installer copies the application to `/opt/reflex-game`, creates a restricted `reflex-web` user, installs a hardened `reflex-game.service`, enables automatic startup, and listens on port 80.

Administration:

```bash
sudo systemctl status reflex-game
sudo systemctl restart reflex-game
sudo systemctl stop reflex-game
sudo journalctl -u reflex-game -f
```

## Other operating systems

### macOS

Python 3 is required. Run:

```bash
chmod +x install-macos.sh
./install-macos.sh
```

The app is installed in `~/Applications/ReflexGame` and served on port `8080`. The script creates a LaunchAgent so it starts when the user signs in.

### Windows

Run PowerShell as Administrator:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install-windows.ps1
```

The app is installed under `%LOCALAPPDATA%\ReflexGame` and served on port `8080`. The installer creates a scheduled task for sign-in startup.

## Development

For a local preview:

```bash
python3 server.py
```

By default the packaged server expects files in `public/`. For development from the repository root:

```bash
REFLEX_ROOT=. REFLEX_PORT=8080 python3 server.py
```

Main files:

- `index.html`: accessible page structure.
- `app.js`: game state, input, statistics, settings, sounds, and storage.
- `styles.css`: base visual system.
- `effects.css`: gameplay and success animations.
- `mobile.css`: touch UI and responsive adjustments.
- `server.py`: dependency-free static HTTP server.
- `install.sh`: Linux installer.

## Privacy and offline use

The game loads no remote fonts, scripts, images, or analytics. Once installed locally it works without Internet access. Results never leave the browser.

## License

MIT — see [LICENSE](LICENSE).
