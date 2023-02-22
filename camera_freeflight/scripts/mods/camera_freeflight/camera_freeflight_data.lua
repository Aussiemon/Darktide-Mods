local mod = get_mod("camera_freeflight")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
}

mod_data.options = {
  widgets = {
    {
      setting_id    = "cf_toggle_freeflight",
      type          = "keybind",
      default_value = {},
      keybind_global  = true,
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      function_name   = "toggle_freeflight",
    },
    {
      setting_id    = "cf_teleport_player",
      type          = "checkbox",
      default_value = false,
    },
  }
}

return mod_data
