-- dropdown.lua
-- Configuration exclusively for the drop-down WezTerm instance.
-- Launched via: wezterm --config-file ~/.config/wezterm/dropdown.lua start ...
--
-- WHY a separate file and not a single wezterm.lua:
--   WezTerm on Wayland cannot reliably change config per-window using Lua events
--   (event timing is async and causes flicker). Using --config-file at launch
--   guarantees the correct options are loaded from the start, with no race conditions.
local wezterm = require 'wezterm'
local config  = wezterm.config_builder()

config.color_scheme             = 'Dracula'
config.window_background_opacity = 0.85
config.font                     = wezterm.font 'JetBrains Mono'
config.font_size                = 11.0

-- No tab bar — the dropdown is a single session, the tab bar is never needed.
config.enable_tab_bar = false

-- CRITICAL: Use "RESIZE", NOT "NONE".
-- With "NONE", WezTerm tells KDE Wayland "I am a native fullscreen surface".
-- KDE then memorises the original monitor size and forces it on minimize/restore,
-- breaking multi-monitor repositioning (window appears with the old monitor's dimensions).
-- With "RESIZE", KDE treats it as a normal resizable window and respects geometry changes.
config.window_decorations = "RESIZE"

return config
