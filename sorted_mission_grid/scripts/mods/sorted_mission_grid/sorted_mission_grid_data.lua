local mod = get_mod("sorted_mission_grid")

local flash_mission_offsets = {
  115,
  540,
}
local quickplay_mission_offsets = {
  115,
  720,
}
local mission_type_selection_offsets = {
  0,
  800,
}
local story_mission_view_frame_offsets = {
  825,
  0,
}
local story_mission_view_button_offsets = {
  825,
  0,
}

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
    quickplay_mission_position = quickplay_mission_offsets,
    flash_mission_position = flash_mission_offsets,
    mission_type_selection_position = mission_type_selection_offsets,
    story_mission_view_frame_position = story_mission_view_frame_offsets,
    story_mission_view_button_position = story_mission_view_button_offsets,
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
    quickplay_mission_position = quickplay_mission_offsets,
    flash_mission_position = flash_mission_offsets,
    mission_type_selection_position = mission_type_selection_offsets,
    story_mission_view_frame_position = story_mission_view_frame_offsets,
    story_mission_view_button_position = story_mission_view_button_offsets,
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

mod.circumstance_difficulty_order = {
  "exploration_mode_01",
  "dummy_less_resistance_01",
  "less_resistance_01",
  "darkness_less_resistance_01",
  "hunting_grounds_less_resistance_01",
  "min_resistance_max_challenge_01",
  "min_challenge_max_resistance_01",
  "ventilation_purge_less_resistance_01",
  "ventilation_purge_with_snipers_less_resistance_01",
  "default",
  "hub_skulls",
  "flash_mission_01",
  "flash_mission_02",
  "flash_mission_03",
  "flash_mission_04",
  "flash_mission_05",
  "flash_mission_06",
  "flash_mission_07",
  "flash_mission_08",
  "flash_mission_09",
  "flash_mission_10",
  "flash_mission_11",
  "flash_mission_12",
  "flash_mission_13",
  "flash_mission_14",
  "waves_of_specials_less_resistance_01",
  "ventilation_purge_01",
  "six_one_01",
  "six_one_flash_mission_01",
  "six_one_flash_mission_02",
  "six_one_flash_mission_03",
  "six_one_flash_mission_04",
  "noir_01",
  "nurgle_manifestation_01",
  "assault_01",
  "darkness_01",
  "heretical_disruption_01",
  "hunting_grounds_01",
  "bolstering_minions_01",
  "gas_01",
  "ember_01",
  "toxic_gas_01",
  "snipers_01",
  "poxwalker_bombers_01",
  "mutants_01",
  "more_witches_01",
  "more_specials_01",
  "more_monsters_01",
  "more_hordes_01",
  "more_boss_patrols_01",
  "more_captains_01",
  "toxic_gas_twins_01",
  "toxic_gas_volumes_01",
  "high_flash_mission_01",
  "high_flash_mission_02",
  "high_flash_mission_03",
  "high_flash_mission_04",
  "high_flash_mission_05",
  "high_flash_mission_06",
  "high_flash_mission_07",
  "high_flash_mission_08",
  "high_flash_mission_09",
  "high_flash_mission_10",
  "high_flash_mission_11",
  "high_flash_mission_12",
  "high_flash_mission_13",
  "high_flash_mission_14",
  "stealth_01",
  "speedrun_challenge_01",
  "darkness_hunting_grounds_01",
  "ventilation_purge_with_snipers_01",
  "monster_specials_01",
  "waves_of_specials_01",
  "more_resistance_01",
  "ventilation_purge_more_resistance_01",
  "dummy_more_resistance_01",
  "only_melee_01",
  "only_melee_no_ammo_01",
  "only_ranged_01",
  "solo_mode_01",
  "darkness_more_resistance_01",
  "hunting_grounds_more_resistance_01",
  "ventilation_purge_with_snipers_more_resistance_01",
  "waves_of_specials_more_resistance_01",
  "monster_specials_more_specials_more_resistance_01",
}

mod.circumstance_value = {}
for i, circumstance in ipairs(mod.circumstance_difficulty_order) do
  mod.circumstance_value[circumstance] = i
end

-- local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
-- local missing_templates = {}
-- for key, val in pairs(CircumstanceTemplates) do
--   if not mod.circumstance_value[key] then
--     missing_templates[#missing_templates + 1] = key
--   end
-- end
-- mod:dump(missing_templates, "missing_templates", 3)

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
