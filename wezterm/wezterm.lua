-- wezterm.lua
-- Optional example launcher config if you want the normal window to match the dropdown.
local wezterm = require 'wezterm'
local base = require 'dropdown_base'
local config = wezterm.config_builder()

-- Aplicamos la base compartida
base.apply(config)

-- Configuraciones específicas para la ventana normal
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations       = "TITLE | RESIZE"

return config
