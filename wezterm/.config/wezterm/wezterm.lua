local wezterm = require("wezterm")
local config = wezterm.config_builder()
local keys = {}

config.default_prog = { '/usr/bin/fish', '-l' }
config.default_gui_startup_args = { 'connect', 'unix' }

config.use_fancy_tab_bar = false

local light_scheme = "GruvboxLight"
local dark_scheme = "GruvboxDark"
config.color_scheme = dark_scheme
config.max_fps = 144
config.font = wezterm.font {
	family = "JetBrains Mono",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
}

config.default_workspace = "0"
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace() .. " ")
end)
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
table.insert(keys, { mods = "LEADER", key = "s", action = workspace_switcher.switch_workspace() })
local workspace_count = 1
local create_workspace = wezterm.action.PromptInputLine {
	description = wezterm.format {
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { AnsiColor = "Fuchsia" } },
		{ Text = "Enter name for new workspace (or leave blank for index)" },
	},
	action = wezterm.action_callback(function(window, pane, line)
		-- line will be `nil` if they hit escape without entering anything
		-- An empty string if they just hit enter
		-- Or the actual line of text they wrote
		if line == nil then
			return
		end
		if line == "" then
			window:perform_action(wezterm.action.SwitchToWorkspace { name = tostring(workspace_count) }, pane)
			workspace_count = workspace_count + 1
		else
			window:perform_action(wezterm.action.SwitchToWorkspace { name = line }, pane)
		end
	end),
}
table.insert(keys, { mods = "LEADER", key = "n", action = create_workspace } )

config.leader = { key = "g", mods = "CTRL", timeout_milliseconds = 1000 }
table.insert(keys, { mods = "LEADER", key = "=", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } })
table.insert(keys, { mods = "LEADER", key = "-", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } })
table.insert(keys, { mods = "LEADER", key = "h", action = wezterm.action { ActivatePaneDirection = "Left" } })

table.insert(keys, { mods = "LEADER|CTRL", key = "h", action = wezterm.action { ActivatePaneDirection = "Left" } })
table.insert(keys, { mods = "LEADER|CTRL", key = "j", action = wezterm.action { ActivatePaneDirection = "Down" } })
table.insert(keys, { mods = "LEADER|CTRL", key = "k", action = wezterm.action { ActivatePaneDirection = "Up" } })
table.insert(keys, { mods = "LEADER|CTRL", key = "l", action = wezterm.action { ActivatePaneDirection = "Right" } })

table.insert(keys, { mods = "LEADER", key = "h", action = wezterm.action { ActivatePaneDirection = "Left" } })
table.insert(keys, { mods = "LEADER", key = "j", action = wezterm.action { ActivatePaneDirection = "Down" } })
table.insert(keys, { mods = "LEADER", key = "k", action = wezterm.action { ActivatePaneDirection = "Up" } })
table.insert(keys, { mods = "LEADER", key = "l", action = wezterm.action { ActivatePaneDirection = "Right" } })

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

table.insert(keys, { mods = "LEADER", key = "t", action = wezterm.action{EmitEvent="toggle-dark-mode"},})

for i = 0,8 do
	table.insert(keys, { mods = "LEADER", key = tostring(i + 1), action = wezterm.action.ActivateTab(i) })
end
config.keys = keys

return config
