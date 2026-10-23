local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local home_dir = os.getenv("HOME")

-- This is where you actually apply your config choices

config.font_size = 15
config.font = wezterm.font { family = 'JetBrainsMono Nerd Font' }

local background_image_path = os.getenv("WEZTERM_BG_IMAGE") or (home_dir .. '/Github/dotfiles/images/a_motorcycle_parked_outside_a_restaurant.jpg')
config.window_background_image = background_image_path
config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 1
config.window_background_image_hsb = {
  hue = 1.0,
  saturation = 0.7,
  brightness = 0.03,
}

-- config.color_scheme = 'Raycast_Dark'

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
