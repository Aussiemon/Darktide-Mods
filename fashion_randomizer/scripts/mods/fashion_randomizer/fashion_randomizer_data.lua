local mod = get_mod("fashion_randomizer")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
}

mod_data.options = {
  widgets = {
    {
      setting_id    = "fr_equip_keybind",
      type          = "keybind",
      default_value = {},
      keybind_global  = true,
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      function_name   = "equip_random_items",
    },
    {
      setting_id    = "fr_respect_archetypes",
      type          = "checkbox",
      default_value = true,
    },
  }
}

for _, slot_type in ipairs(mod.player_slots) do
  table.insert(mod_data.options.widgets, {
    setting_id    = mod.player_slots_setting_map[slot_type],
    type          = "checkbox",
    default_value = not (string.find(slot_type, "_body"))
  })
end

return mod_data
