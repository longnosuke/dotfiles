-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font_size = 20
config.font = wezterm.font { family = 'JetBrainsMono Nerd Font' }

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.color_scheme = 'Konsolas'

config.keys = {
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.Multiple {
      wezterm.action.ClearScrollback 'ScrollbackAndViewport',
      wezterm.action.SendKey { key = 'L', mods = 'CTRL' },
    },
  },
}

-- and finally, return the configuration to wezterm

return config
