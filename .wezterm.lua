-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Choosing the color scheme
config.color_scheme = "Sea Shells (Gogh)"

-- and finally, return the configuration to wezterm
return config
