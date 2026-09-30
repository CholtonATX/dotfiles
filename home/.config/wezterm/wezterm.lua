local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Theme and Appearance
config.color_scheme = 'Aci (Gogh)'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 14.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50

-- macOS Integration
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

return config
