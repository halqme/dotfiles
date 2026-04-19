local wezterm = require("wezterm")
local act = wezterm.action


return {
  keys = {
    { key = "h",   mods = "SHIFT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- Ctrl+Shift+hで新しいペインを作成(画面を分割)
    { key = "Tab", mods = "CTRL",       action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    { key = "v",   mods = "CMD",        action = act.PasteFrom("Clipboard") },
    { key = "v",   mods = "SHIFT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) }, -- Ctrl+Shift+vで新しいペインを作成(画面を分割)
    { key = "n",   mods = "CMD",        action = act.newWindow({ domain = "CurrentPaneDomain" }) },
  }
}
