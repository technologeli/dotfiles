local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "GruvboxDark"

config.font = wezterm.font {
	family = "JetBrains Mono",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
}

return config
