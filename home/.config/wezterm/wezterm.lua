local wezterm = require("wezterm")
local mux = wezterm.mux

local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window()
  local screen = wezterm.gui.screens().active
  local dimensions = gui_window:get_dimensions()

  gui_window:set_position(
    screen.x + (screen.width - dimensions.pixel_width) / 2,
    screen.y + (screen.height - dimensions.pixel_height) / 2
  )
end)

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.initial_cols = 140
config.initial_rows = 40
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

return config
