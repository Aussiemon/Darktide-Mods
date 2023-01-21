local mod = get_mod("bot_spawner")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
}

mod_data.options = {
  widgets = {
    {
      setting_id    = "next_bot_on_spawn",
      type          = "checkbox",
      default_value = true,
    },
    {
      setting_id    = "key_spawn_bot",
      type          = "keybind",
      default_value = {},
      keybind_global  = true,
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      function_name   = "spawn_bot",
    },
    {
      setting_id    = "key_next_bot",
      type          = "keybind",
      default_value = {},
      keybind_global  = true,
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      function_name   = "next_bot",
    },
    {
      setting_id    = "key_despawn_bot",
      type          = "keybind",
      default_value = {},
      keybind_global  = true,
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      function_name   = "despawn_bot",
    },
  }
}

return mod_data
