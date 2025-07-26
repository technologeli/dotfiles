local wezterm = require("wezterm")
local config = wezterm.config_builder()
local keys = {}

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

local light_scheme = "GruvboxLight"
local dark_scheme = "GruvboxDark"
config.color_scheme = dark_scheme
config.max_fps = 144
config.font = wezterm.font {
	family = "JetBrains Mono",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
}

config.default_workspace = "0"
wezterm.on("toggle-dark-mode", function(window,pane)
  local overrides = window:get_config_overrides() or {}
  if (overrides.color_scheme == light_scheme)
  then
    overrides.color_scheme = dark_scheme
  else
    overrides.color_scheme = light_scheme
  end
  window:set_config_overrides(overrides)
end)

config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }
table.insert(keys, { mods = "LEADER", key = "t", action = wezterm.action{EmitEvent="toggle-dark-mode"},})

config.keys = keys

return config
