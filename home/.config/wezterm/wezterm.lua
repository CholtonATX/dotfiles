local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()

-- Theme and Appearance
config.color_scheme = 'Aci (Gogh)'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 14.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20

-- Layout
wezterm.on('gui-startup', function(cmd)
  local tab, top, window = mux.spawn_window(cmd or {})
  local bottom = top:split { direction = 'Bottom' }
  bottom:split { direction = 'Right' }
end)

-- macOS Integration
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- Cmd+C copies when text is selected, otherwise sends Ctrl+C to the process
config.keys = {
  {
    key = 'c',
    mods = 'SUPER',
    action = wezterm.action_callback(function(window, pane)
      if window:get_selection_text_for_pane(pane) ~= '' then
        window:perform_action(wezterm.action.CopyTo 'Clipboard', pane)
      else
        window:perform_action(wezterm.action.SendKey { key = 'c', mods = 'CTRL' }, pane)
      end
    end),
  },
}

return config
