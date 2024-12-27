-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- config.font = wezterm.font("MesloLGS NF")
config.font = wezterm.font("Operator Mono SSm Nerd Lig", { weight = "Light" })
config.font_size = 15
config.line_height = 1.35
config.initial_rows = 60
config.initial_cols = 400

config.enable_tab_bar = false

-- config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"

config.window_background_opacity = 0.85
config.macos_window_background_blur = 100
config.max_fps = 120

config.colors = {
	foreground = "#CBCCC6", -- Foreground (Text)
	background = "#1F2430", -- Background
	cursor_bg = "#FFCC66", -- Cursor
	cursor_border = "#FFCC66",
	cursor_fg = "#1F2430",
	selection_bg = "#707A8C",
	selection_fg = "#CBCCC6",

	ansi = {
		"#1F2430", -- Black (Host)
		"#FF3333", -- Red (Syntax string)
		"#BAE67E", -- Green (Command)
		"#FFA759", -- Yellow (Command second)
		"#707A8C", -- Blue (Path) ** Changed
		"#D4BFFF", -- Magenta (Syntax var)
		"#95E6CB", -- Cyan (Prompt)
		"#CBCCC6", -- White
	},
	brights = {
		"#707A8C", -- Bright Black
		"#FF3333", -- Bright Red (Command error)
		"#BAE67E", -- Bright Green (Exec)
		"#FFA759", -- Bright Yellow
		"#73D0FF", -- Bright Blue (Folder)
		"#D4BFFF", -- Bright Magenta
		"#95E6CB", -- Bright Cyan
		"#CBCCC6", -- Bright White
	},
}

config.keys = {
	{

		key = "A",
		mods = "CTRL|SHIFT",
		action = wezterm.action.QuickSelect,
	},
	{
		key = ".",
		mods = "CTRL",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "c",
		mods = "CMD",
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if not sel or sel == "" then
				window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
			else
				window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
			end
		end),
	},
}

config.font_rules = {

	{
		intensity = "Bold",
		font = wezterm.font("Operator Mono SSm Nerd Lig", { weight = "Light" }),
	},
}

config.window_padding = {
	left = "2cell",
	right = "2cell",
	top = ".3cell",
	bottom = 0,
}

return config
