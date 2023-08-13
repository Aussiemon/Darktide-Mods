local mod = get_mod("sorted_mission_grid")

mod.custom_mission_positions = {
  normal = {
    {
      115,
      120,
      index = 1,
      prefered_danger = 5
    },
    {
      315,
      120,
      index = 2,
      prefered_danger = 5
    },
    {
      515,
      120,
      index = 3,
      prefered_danger = 5
    },
    {
      715,
      120,
      index = 4,
      prefered_danger = 5
    },
    {
      915,
      120,
      index = 5,
      prefered_danger = 5
    },
    {
      1115,
      120,
      index = 6,
      prefered_danger = 5
    },
    {
      115,
      320,
      index = 7,
      prefered_danger = 5
    },
    {
      315,
      320,
      index = 8,
      prefered_danger = 5
    },
    {
      515,
      320,
      index = 9,
      prefered_danger = 5
    },
    {
      715,
      320,
      index = 10,
      prefered_danger = 5
    },
    {
      915,
      320,
      index = 11,
      prefered_danger = 5
    },
    {
      1115,
      320,
      index = 12,
      prefered_danger = 5
    },
    {
      515,
      520,
      index = 13,
      prefered_danger = 5
    },
    {
      715,
      520,
      index = 14,
      prefered_danger = 5
    },
    {
      915,
      520,
      index = 15,
      prefered_danger = 5
    },
    {
      1115,
      520,
      index = 16,
      prefered_danger = 5
    },
    {
      515,
      720,
      index = 17,
      prefered_danger = 5
    },
    {
      715,
      720,
      index = 18,
      prefered_danger = 5
    },
    {
      915,
      720,
      index = 19,
      prefered_danger = 5
    },
    {
      1115,
      720,
      index = 20,
      prefered_danger = 5
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
  }
}
mod.custom_mission_positions.auric = mod.custom_mission_positions.normal

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
