local mod = get_mod("reroll_until_rarity")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
}

-- All setting_id and dropdown text ids are automatically run through mod:localize()
mod_data.options = {
  widgets = {
    {
      setting_id      = "rur_desired_rarity",
      type            = "numeric",
      default_value   = 4,
      range           = {1, 4},
    },
    {
      setting_id      = "rur_max_attempts",
      type            = "numeric",
      default_value   = 10,
      range           = {1, 1000},
    },
    {
      setting_id      = "rur_cancel_keybind",
      type            = "keybind",
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      default_value   = {},
      function_name   = "cancel_operation"
    },
  }
}

return mod_data
