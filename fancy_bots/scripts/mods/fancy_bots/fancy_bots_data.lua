local mod = get_mod("fancy_bots")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
}

mod_data.options = {
  widgets = {
    {
      setting_id    = "fb_randomize",
      type          = "checkbox",
      default_value = false,
    },
  }
}

-- for _, slot_type in ipairs(mod.player_slots) do
--   table.insert(mod_data.options.widgets, {
--     setting_id    = mod.player_slots_setting_map[slot_type],
--     type          = "checkbox",
--     default_value = not (string.find(slot_type, "_body"))
--   })
-- end

return mod_data
