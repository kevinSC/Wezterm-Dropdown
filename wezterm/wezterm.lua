-- wezterm.lua
-- Standard WezTerm configuration — loaded when launching from the app launcher.
-- For the dropdown instance, see dropdown.lua (launched via --config-file).
local wezterm = require 'wezterm'
local config  = wezterm.config_builder()

config.color_scheme             = 'Dracula'
config.window_background_opacity = 0.85
config.font                     = wezterm.font 'JetBrains Mono'
config.font_size                = 11.0
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations       = "TITLE | RESIZE"

return config
