-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- imput method
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

-- tab_bar
config.show_new_tab_button_in_tab_bar = false
config.show_tabs_in_tab_bar = true
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
config.tab_bar_style = {

}

-- windows setting
config.initial_rows = 36
config.initial_cols = 120
config.window_decorations = "NONE"
config.macos_window_background_blur = 3
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
  left = '0px',
  right = '0px',
  bottom = '0px',
  top = '0pt',
}
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none"
}
config.enable_scroll_bar = false

-- color scheme and face:
config.color_scheme = "Nord (base16)"
config.text_background_opacity = 1
config.window_background_opacity = 0.1

-- Background pics
local function getImgaes()
  local command = '\\find ~/Pictures/Wallpaper.Collections/*'
  local file = io.popen(command, "r")
  if not file then
    return {}
  end
  local images = {}
  for line in file:lines() do
    table.insert(images, tostring(line))
  end
  file:close()
  return images
end

local images = getImgaes()

-- 配列からランダムな画像を選択する関数
local function get_random_image()
  math.randomseed(os.time())
  local index = math.random(1, #images)
  return images[index]
end

print(get_random_image())

-- ウィンドウが再読み込みされるたびにランダムな画像を設定
local last_image_time = 0
local last_image = nil

local function set_background_image(window, pane)
  local now = os.time()
  if last_image == nil or (now - last_image_time) >= 0.5 then
    local next_image = get_random_image()
    if last_image == next_image then
      next_image = get_random_image()
    end
    last_image = next_image
    last_image_time = now
  end
  local overrides = window:get_config_overrides() or {}
  overrides.background = {
    {
      source = {
        File = last_image,
      },
      opacity = 0.80,
      hsb = { brightness = 0.05 },
    },
  }
  window:set_config_overrides(overrides)
end

wezterm.on("window-focus-changed", function(window, pane)
  if not (window:is_focused()) then
    set_background_image(window, pane)
  end
end)

wezterm.on("window-config-reloaded", function(window, pane)
  set_background_image(window, pane)
end)

-- fonts
config.font = wezterm.font_with_fallback({ "Moralerspace Xenon" })
config.font_size = 14.5
config.adjust_window_size_when_changing_font_size = false

-- cursor conf
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 750

-- leader
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }

-- and finally, return the configuration to wezterm
return config
