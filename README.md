# WezTerm Dropdown for KDE Plasma 6 (Wayland)

A native drop-down terminal powered by [WezTerm](https://wezfurlong.org/wezterm/) on **KDE Plasma 6 + Wayland**, with smooth slide animations and multi-monitor support.

> **Platform:** Arch Linux · KDE Plasma 6 · Wayland  
> **Dependencies:** `wezterm` `kdotool` `python3` (`kscreen-doctor` comes with `plasma-workspace`)

---

## Features

- **Slide-in/out animation** — cubic easing (ease-out on show, ease-in on hide) at ~28 fps
- **Multi-monitor aware** — the terminal always appears on the monitor where the mouse cursor is
- **Instant toggle** — a single keyboard shortcut shows/hides the dropdown
- **Borderless fake-fullscreen** — no title bar, full monitor width, anchored to the top
- **Separate config** — dropdown instance uses its own `dropdown.lua` + `dropdown_base.lua`, independent of your normal WezTerm config

---

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/wezternconf.git ~/Experiments/Wezterm/Wezternconf
cd ~/Experiments/Wezterm/Wezternconf
./install.sh
```

> The repo can live anywhere. The installer resolves paths from its own directory; `~/Experiments/Wezterm/Wezternconf` is just the workspace layout used here.

The install script creates **symlinks** from the standard system paths to this repo:

| System path | Points to |
|---|---|
| `~/.config/wezterm/dropdown.lua` | `wezterm/dropdown.lua` |
| `~/.config/wezterm/dropdown_base.lua` | `wezterm/dropdown_base.lua` |
| `~/.config/wezterm/bin/wezterm-toggle.sh` | `scripts/wezterm-toggle.sh` |
| `~/.local/share/kwin/scripts/wezterm-dropdown` | `kwin/wezterm-dropdown/` |

This means you can `git pull` to update everything — no manual file copying needed.

The installer intentionally does **not** overwrite `~/.config/wezterm/wezterm.lua`, so you can keep your own normal WezTerm config or pair this repo with another one.

---

## Dependencies

Install on Arch Linux:

```bash
sudo pacman -S wezterm kdotool python ttf-jetbrains-mono
# kscreen-doctor comes bundled with plasma-workspace
```

---

## Setup

### 1. Run the installer

```bash
./install.sh
```

### 2. Add the keyboard shortcut

- Open **System Settings → Shortcuts → Add Command / URL**
- Click **Add new → Command**
- **Name:** `WezTerm Dropdown`
- **Command:** `~/.config/wezterm/bin/wezterm-toggle.sh`
- **Shortcut:** `Ctrl+Alt+T` (or your preference)

### 3. Test it

```bash
~/.config/wezterm/bin/wezterm-toggle.sh
```

Press the shortcut again to hide it. Move your mouse to another monitor and press again — the terminal follows the cursor.

---

## How it works

### Three-case toggle logic

| State | Action |
|---|---|
| Window doesn't exist | Launch WezTerm, move off-screen immediately, slide in |
| Window is active (focused) | Slide up and minimize |
| Window exists but hidden | Teleport to current monitor, slide in |

### Why `kdotool` and not `xdotool`?

Wayland prevents applications from manipulating windows of other apps (a security restriction of the protocol). `kdotool` is KDE-specific and communicates through KWin's internal protocol, bypassing that restriction officially.

### Why `kscreen-doctor`?

It's KDE's official tool for querying monitor geometry (position X,Y and size WxH in the virtual pixel space). Its output contains ANSI color codes — Python strips them before parsing.

### Why cubic easing?

- **Ease-out** (on show): fast start, soft landing → feels like gravity pulling the terminal down
- **Ease-in** (on hide): slow start, fast exit → feels like being flung upward  
Linear movement feels mechanical; easing feels natural.

### Why `window_decorations = "RESIZE"` and not `"NONE"`?

With `"NONE"`, WezTerm signals to KDE Wayland that it's a native fullscreen surface. KDE then memorises the original monitor dimensions and forces them on minimize/restore — **breaking multi-monitor repositioning**. With `"RESIZE"`, KDE treats it as a normal resizable window and respects geometry changes freely.

---

## Uninstall

```bash
./uninstall.sh
```

Removes all symlinks. If a file was backed up during install (`*.bak`), it is restored automatically.

---

## Repository structure

```
.
├── install.sh                    ← creates symlinks
├── uninstall.sh                  ← removes symlinks
├── wezterm/
│   ├── dropdown.lua              ← dropdown-specific config (no title bar)
│   ├── dropdown_base.lua         ← shared defaults used by the dropdown config
│   └── wezterm.lua               ← optional launcher example with matching style
├── scripts/
│   └── wezterm-toggle.sh         ← toggle script (animation + multi-monitor)
└── kwin/
    └── wezterm-dropdown/         ← KWin script (keyboard shortcut registration)
        ├── metadata.json
        └── contents/code/main.js
```

---

## License

GPLv3
