local wezterm = require("wezterm")

-- ============================================================
-- 탭 타이틀 커스텀 포맷
-- ============================================================
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local active_pane = tab.active_pane

	local process = "shell"
	if active_pane.foreground_process_name then
		process = string.match(active_pane.foreground_process_name, "([^/\\]+)$") or "shell"
		process = process:gsub("%.exe$", "")
	end

	local cwd_short = ""
	if active_pane.current_working_dir then
		local cwd = tostring(active_pane.current_working_dir)
		cwd = cwd:gsub("^file://[^/]+", "")
		local home = os.getenv("HOME") or ""
		if home ~= "" and cwd:sub(1, #home) == home then
			cwd = "~" .. cwd:sub(#home + 1)
		end
		cwd_short = string.match(cwd, "([^/]+)/?$") or cwd
		if cwd == "~" or cwd == "/" then
			cwd_short = cwd
		end
	end

	local idx = tab.tab_index + 1
	local indicator = tab.is_active and "●" or "○"

	return string.format(" %s %d │ %s │ %s ", indicator, idx, process, cwd_short)
end)

-- ============================================================
-- 폰트
-- ============================================================
local function font_with_fallback(name, params)
	local names = { name, "Apple Color Emoji", "azuki_font" }
	return wezterm.font_with_fallback(names, params)
end

local font_name = "Cascadia Code"

return {
	default_domain = "WSL:Ubuntu-24.04",
	front_end = "OpenGL",

	font = font_with_fallback(font_name),
	font_size = 12.0,
	line_height = 1.0,
	font_rules = {
		{ italic = true, font = font_with_fallback(font_name, { italic = true }) },
		{ italic = true, intensity = "Bold", font = font_with_fallback(font_name, { italic = true, bold = true }) },
		{ intensity = "Bold", font = font_with_fallback(font_name, { bold = true }) },
	},
	warn_about_missing_glyphs = false,

	-- 색상
	color_scheme = "Dracula",
	colors = {
		tab_bar = {
			background = "#191A21",
			active_tab = { bg_color = "#BD93F9", fg_color = "#191A21", intensity = "Bold" },
			inactive_tab = { bg_color = "#282A36", fg_color = "#6272A4" },
			inactive_tab_hover = { bg_color = "#44475A", fg_color = "#F8F8F2" },
			new_tab = { bg_color = "#282A36", fg_color = "#6272A4" },
			new_tab_hover = { bg_color = "#FF79C6", fg_color = "#191A21" },
		},
	},

	-- 창/탭
	window_background_opacity = 0.9,
	window_close_confirmation = "NeverPrompt",
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	show_tab_index_in_tab_bar = false,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	tab_max_width = 40,
	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	window_frame = {
		active_titlebar_bg = "#090909",
		font = font_with_fallback(font_name, { bold = true }),
	},

	-- 커서/스크롤
	default_cursor_style = "BlinkingBlock",
	scrollback_lines = 10000,
	audible_bell = "Disabled",
	animation_fps = 30,

	-- ============================================================
	-- 키바인딩
	-- ============================================================
	disable_default_key_bindings = true,
	keys = {
		-- Mac 스타일 Ctrl+C / Ctrl+V
		{
			key = "c",
			mods = "CTRL",
			action = wezterm.action_callback(function(window, pane)
				local has_selection = window:get_selection_text_for_pane(pane) ~= ""
				if has_selection then
					window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
					window:perform_action(wezterm.action.ClearSelection, pane)
				else
					window:perform_action(wezterm.action({ SendKey = { key = "c", mods = "CTRL" } }), pane)
				end
			end),
		},
		{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },

		-- 표준 복붙 (백업)
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }) },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },

		-- Pane 분할
		{ key = [[\]], mods = "CTRL|ALT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = [[\]], mods = "CTRL", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

		-- [변경] Pane 닫기: Ctrl+Q → Ctrl+Shift+W
		-- Ctrl+Q는 vim 블록 비주얼/셸로 통과시키기 위해 해제
		{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },

		-- Pane 이동
		{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },

		-- Pane 크기 조절
		{ key = "h", mods = "CTRL|SHIFT|ALT", action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }) },
		{ key = "l", mods = "CTRL|SHIFT|ALT", action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }) },
		{ key = "k", mods = "CTRL|SHIFT|ALT", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
		{ key = "j", mods = "CTRL|SHIFT|ALT", action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }) },

		-- 탭
		{ key = "t", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CTRL", action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },
		{ key = "Tab", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },

        -- 폰트 크기 (Cmd+= / Cmd+- / Cmd+0)
        { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
        { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
        { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },

        -- 검색 (Cmd+F)
        { key = "f", mods = "CTRL", action = wezterm.action.Search({ CaseSensitiveString = "" }) },

        -- 전체 선택 (Cmd+A) — 현재 화면 전체 텍스트 복사
        -- 주의: 셸의 Ctrl+A(라인 시작)와 충돌하니 비추. 필요하면 SHIFT 조합으로:
        { key = "a", mods = "CTRL|SHIFT", action = wezterm.action.SelectTextAtMouseCursor("SemanticZone") },

        -- 새 창 (Cmd+N) — WezTerm은 SpawnWindow 라고 함
        { key = "n", mods = "CTRL", action = wezterm.action.SpawnWindow },


		-- Copy 모드
		{ key = "x", mods = "CTRL", action = "ActivateCopyMode" },
	},

	-- 기타
	enable_wayland = false,
	automatically_reload_config = true,
	inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
}
