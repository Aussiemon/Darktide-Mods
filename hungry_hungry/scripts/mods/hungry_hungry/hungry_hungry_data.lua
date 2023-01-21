local mod = get_mod("hungry_hungry")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
}

-- All setting_id and dropdown text ids are automatically run through mod:localize()
mod_data.options = {
  widgets = {
    {
      setting_id    = "hh_no_player_conditions",
      type          = "checkbox",
      default_value = false,
    },
    {
      setting_id    = "hh_no_player_cooldown",
      type          = "checkbox",
      default_value = true,
    },
    {
      setting_id    = "hh_no_minion_conditions",
      type          = "checkbox",
      default_value = true,
    },
    {
      setting_id    = "hh_no_minion_cooldown",
      type          = "checkbox",
      default_value = true,
    },
    {
      setting_id    = "hh_eat_everything",
      type          = "checkbox",
      default_value = true,
    }
  }
}

return mod_data
