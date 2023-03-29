local mod = get_mod("sorted_mission_grid")

mod.custom_mission_positions = {
  {
    100,
    150,
    index = 1
  },
  {
    300,
    150,
    index = 2
  },
  {
    500,
    150,
    index = 3
  },
  {
    700,
    150,
    index = 4
  },
  {
    900,
    150,
    index = 5
  },
  {
    1100,
    150,
    index = 6
  },
  {
    100,
    350,
    index = 7
  },
  {
    300,
    350,
    index = 8
  },
  {
    500,
    350,
    index = 9
  },
  {
    700,
    350,
    index = 10
  },
  {
    900,
    350,
    index = 11
  },
  {
    1100,
    350,
    index = 12
  },
  {
    500,
    550,
    index = 13
  },
  {
    700,
    550,
    index = 14
  },
  {
    900,
    550,
    index = 15
  },
  {
    1100,
    550,
    index = 16
  },
  {
    100,
    750,
    index = 17
  },
  {
    300,
    750,
    index = 18
  },
  {
    500,
    750,
    index = 19
  },
  {
    700,
    750,
    index = 20
  },
  {
    900,
    750,
    index = 21
  },
  {
    1100,
    750,
    index = 22
  }
}

mod.circumstance_value = {
  assault_01 = 14,
  darkness_01 = 15,
  darkness_hunting_grounds_01 = 29,
  darkness_less_resistance_01 = 3,
  darkness_more_resistance_01 = 34,
  default = 8,
  dummy_less_resistance_01 = 1,
  dummy_more_resistance_01 = 33,
  ember_01 = 19,
  gas_01 = 18,
  heretical_disruption_01 = 16,
  hunting_grounds_01 = 17,
  hunting_grounds_less_resistance_01 = 4,
  hunting_grounds_more_resistance_01 = 35,
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
  ventilation_purge_with_snipers_01 = 30,
  ventilation_purge_with_snipers_less_resistance_01 = 7,
  ventilation_purge_with_snipers_more_resistance_01 = 36,
  waves_of_specials_01 = 31,
  waves_of_specials_less_resistance_01 = 9,
  waves_of_specials_more_resistance_01 = 37,
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
