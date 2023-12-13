local mod = get_mod("sorted_mission_grid")

mod.custom_mission_positions = {
  normal = {
    {
      115,
      120,
    },
    {
      285,
      120,
    },
    {
      455,
      120,
    },
    {
      625,
      120,
    },
    {
      795,
      120,
    },
    {
      965,
      120,
    },
    {
      1135,
      120,
    },
    {
      115,
      320,
    },
    {
      285,
      320,
    },
    {
      455,
      320,
    },
    {
      625,
      320,
    },
    {
      795,
      320,
    },
    {
      965,
      320,
    },
    {
      1135,
      320,
    },
    {
      455,
      520,
    },
    {
      625,
      520,
    },
    {
      795,
      520,
    },
    {
      965,
      520,
    },
    {
      1135,
      520,
    },
    {
      455,
      720,
    },
    {
      625,
      720,
    },
    {
      795,
      720,
    },
    flash_mission_position = {
      115,
      540
    },
    quickplay_mission_position = {
      115,
      720
    },
    custom = true,
  },
  auric = {
    {
      115,
      120,
    },
    {
      315,
      120,
    },
    {
      515,
      120,
    },
    {
      715,
      120,
    },
    {
      915,
      120,
    },
    {
      1115,
      120,
    },
    {
      115,
      320,
    },
    {
      315,
      320,
    },
    {
      515,
      320,
    },
    {
      715,
      320,
    },
    {
      915,
      320,
    },
    {
      1115,
      320,
    },
    {
      515,
      520,
    },
    {
      715,
      520,
    },
    {
      915,
      520,
    },
    {
      1115,
      520,
    },
    {
      515,
      720,
    },
    {
      715,
      720,
    },
    flash_mission_position = {
      115,
      540
    },
    quickplay_mission_position = {
      115,
      720
    },
    custom = true,
  },
}
for i, mission_position in ipairs(mod.custom_mission_positions.normal) do
  mission_position.index = i
  mission_position.prefered_danger = 5
end
for i, mission_position in ipairs(mod.custom_mission_positions.auric) do
  mission_position.index = i
  mission_position.prefered_danger = 5
end

mod.circumstance_value = {
  assault_01 = 14,
  darkness_01 = 15,
  darkness_hunting_grounds_01 = 29,
  darkness_less_resistance_01 = 3,
  darkness_more_resistance_01 = 35,
  default = 8,
  dummy_less_resistance_01 = 1,
  dummy_more_resistance_01 = 34,
  ember_01 = 19,
  gas_01 = 18,
  heretical_disruption_01 = 16,
  hunting_grounds_01 = 17,
  hunting_grounds_less_resistance_01 = 4,
  hunting_grounds_more_resistance_01 = 36,
  less_resistance_01 = 2,
  min_challenge_max_resistance_01 = 6,
  min_resistance_max_challenge_01 = 5,
  more_hordes_01 = 27,
  more_monsters_01 = 26,
  more_resistance_01 = 32,
  more_specials_01 = 25,
  more_witches_01 = 24,
  mutants_01 = 23,
  noir_01 = 12,
  nurgle_manifestation_01 = 13,
  poxwalker_bombers_01 = 22,
  six_one_01 = 11,
  snipers_01 = 21,
  speedrun_challenge_01 = 28,
  toxic_gas_01 = 20,
  ventilation_purge_01 = 10,
  ventilation_purge_more_resistance_01 = 33,
  ventilation_purge_with_snipers_01 = 30,
  ventilation_purge_with_snipers_less_resistance_01 = 7,
  ventilation_purge_with_snipers_more_resistance_01 = 37,
  waves_of_specials_01 = 31,
  waves_of_specials_less_resistance_01 = 9,
  waves_of_specials_more_resistance_01 = 38,
}

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
}

-- All setting_id and dropdown text ids are automatically run through mod:localize()
mod_data.options = {
  widgets = {
    {
      setting_id    = "smg_auto_refresh",
      type          = "checkbox",
      default_value = true,
    },
    {
      setting_id    = "smg_sort_order",
      type          = "dropdown",
      default_value = "asc",
      options = {
        {text = "asc_setting_text",      value = "asc"},
        {text = "desc_setting_text",     value = "desc"},
        {text = "unsorted_setting_text", value = "unsorted"},
      }
    },
    {
      setting_id      = "smg_refresh_board",
      type            = "keybind",
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      default_value   = {},
      function_name   = "queue_reset_board"
    },
  }
}

return mod_data
