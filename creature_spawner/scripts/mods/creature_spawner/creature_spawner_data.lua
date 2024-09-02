local mod = get_mod("creature_spawner")

mod.regular_units = {}
mod.elite_units = {}
mod.specialist_units = {}
mod.boss_units = {}
mod.misc_units = {}
mod.all_units = {}

mod.breed_blacklist = {
  human = true,
  ogryn = true,
}

mod.unit_category_names = {
  "regular",    -- Spawns in all normal missions
  "elite",      -- Elite units
  "specialist", -- Specialist units
  "boss",       -- Monstrosity units
  "misc",       -- Does not spawn in all normal missions
  "all"         -- All units
}

mod.unit_categories = {
  chaos_beast_of_nurgle = {
    "regular",
    "boss"
  },
  chaos_daemonhost = {
    "regular",
    "boss"
  },
  chaos_hound = {
    "regular",
    "specialist"
  },
  chaos_newly_infected = {
    "regular"
  },
  chaos_ogryn_bulwark = {
    "regular",
    "elite"
  },
  chaos_ogryn_executor = {
    "regular",
    "elite"
  },
  chaos_ogryn_gunner = {
    "regular",
    "elite"
  },
  chaos_plague_ogryn = {
    "regular",
    "boss"
  },
  chaos_plague_ogryn_sprayer = {
    "misc",
    "boss"
  },
  chaos_poxwalker = {
    "regular"
  },
  chaos_poxwalker_bomber = {
    "regular",
    "specialist"
  },
  chaos_spawn = {
    "regular",
    "boss"
  },
  cultist_assault = {
    "regular"
  },
  cultist_berzerker = {
    "regular",
    "elite"
  },
  cultist_flamer = {
    "regular",
    "specialist"
  },
  cultist_grenadier = {
    "regular",
    "specialist"
  },
  cultist_gunner = {
    "regular",
    "elite"
  },
  cultist_melee = {
    "regular"
  },
  cultist_mutant = {
    "regular",
    "specialist"
  },
  cultist_shocktrooper = {
    "regular",
    "elite"
  },
  renegade_assault = {
    "regular"
  },
  renegade_berzerker = {
    "regular",
    "elite"
  },
  renegade_captain = {
    "misc",
    "boss"
  },
  renegade_executor = {
    "regular",
    "elite"
  },
  renegade_flamer = {
    "regular",
    "specialist"
  },
  renegade_grenadier = {
    "regular",
    "specialist"
  },
  renegade_gunner = {
    "regular",
    "elite"
  },
  renegade_melee = {
    "regular"
  },
  renegade_netgunner = {
    "regular",
    "specialist"
  },
  renegade_rifleman = {
    "regular"
  },
  renegade_shocktrooper = {
    "regular",
    "elite"
  },
  renegade_sniper = {
    "regular",
    "specialist"
  },
}

mod:io_dofile("creature_spawner/scripts/mods/creature_spawner/creature_spawner_trials")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
  localize = false,
}

local cs_active_trial_options = {
  { text = "None", value = 0 },
}
for id, trial in pairs(mod.trials) do
  table.insert(cs_active_trial_options, {
    text = trial.trial_name,
    value = id,
  })
end

mod_data.options = {
  widgets = { -- Widget settings for the mod options menu
    { -- Select the active Trial
      ["setting_id"] = "cs_active_trial",
      ["type"] = "dropdown",
      ["default_value"] = 0,
      ["options"] = cs_active_trial_options,
    },
    { -- Selected list of available spawn units
      ["setting_id"] = "cs_unit_list",
      ["type"] = "dropdown",
      ["options"] = {
        {text = "cs_unit_list_header_regular",    value = "regular_units"},
        {text = "cs_unit_list_header_elite",      value = "elite_units"},
        {text = "cs_unit_list_header_specialist", value = "specialist_units"},
        {text = "cs_unit_list_header_boss",       value = "boss_units"},
        {text = "cs_unit_list_header_misc",       value = "misc_units"},
        {text = "cs_unit_list_header_all",        value = "all_units"},
      },
      ["default_value"] = "regular_units", -- Default first option is enabled. In this case regular_units
    },

    --[[
      -- Currently causes a lot of crashes
    { -- Selected team / side of spawned units
      ["setting_id"] = "cs_unit_side",
      ["type"] = "dropdown",
      ["options"] = {
        {text = "cs_unit_side_header_heroes", value = 1},
        {text = "cs_unit_side_header_villains", value = 2},
      },
      ["default_value"] = 2, -- Default first option is enabled. In this case villains
    },
    --]]

    { -- Toggle respawn in Training Grounds
      ["setting_id"] = "cs_enable_training_grounds_respawn",
      ["type"] = "checkbox",
      ["default_value"] = true -- Default first option is enabled. In this case true
    },
    { -- Toggle sound muffler in Training Grounds
      ["setting_id"] = "cs_enable_training_grounds_sound_muffler",
      ["type"] = "checkbox",
      ["default_value"] = false -- Default first option is enabled. In this case false
    },
    { -- Toggle AI in Training Grounds
      ["setting_id"] = "cs_enable_training_grounds_invisibility",
      ["type"] = "checkbox",
      ["default_value"] = true -- Default first option is enabled. In this case true
    },
    { -- Toggle player invulnerability in Training Grounds
      ["setting_id"] = "cs_enable_training_grounds_invulnerability",
      ["type"] = "checkbox",
      ["default_value"] = true -- Default first option is enabled. In this case true
    },

    { -- Keybind for toggling player invisibility
      ["setting_id"] = "cs_enable_training_grounds_invisibility_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "toggle_invisibility"
    },
    { -- Keybind for toggling player invulnerability
      ["setting_id"] = "cs_enable_training_grounds_invulnerability_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "toggle_invulnerability"
    },
    { -- Keybind for spawning units
      ["setting_id"] = "cs_spawn_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "spawn_selected_unit"
    },
    { -- Keybind to move to next unit in list
      ["setting_id"] = "cs_next_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "next_breed"
    },
    { -- Keybind to move to previous unit in list
      ["setting_id"] = "cs_prev_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "previous_breed"
    },
    { -- Keybind to destroy all spawned units
      ["setting_id"] = "cs_destroy_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "despawn_units"
    },

    { -- Keybind to spawn first saved unit
      ["setting_id"] = "cs_spawn_saved_unit_one_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "spawn_saved_unit_one"
    },
    { -- Keybind to spawn second saved unit
      ["setting_id"] = "cs_spawn_saved_unit_two_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "spawn_saved_unit_two"
    },
    { -- Keybind to spawn third saved unit
      ["setting_id"] = "cs_spawn_saved_unit_three_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "spawn_saved_unit_three"
    },

    { -- Keybind to heal the player
      ["setting_id"] = "cs_heal_player_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "heal_player"
    },
    { -- Keybind to restore toughness to the player
      ["setting_id"] = "cs_add_toughness_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "add_toughness"
    },
    { -- Keybind to assist the player
      ["setting_id"] = "cs_assist_player_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "assist_player"
    },
    { -- Keybind to reset combat ability cooldown
      ["setting_id"] = "cs_reset_combat_ability_cooldown_keybind",
      ["type"] = "keybind",
      ["keybind_trigger"] = "pressed",
      ["keybind_type"] = "function_call",
      ["default_value"] = {},
      ["function_name"] = "reset_combat_ability_cooldown"
    },
    { -- Keybind to switch to the previous trial
        ["setting_id"] = "cs_previous_trial_keybind",
        ["type"] = "keybind",
        ["keybind_trigger"] = "pressed",
        ["keybind_type"] = "function_call",
        ["default_value"] = {},
        ["function_name"] = "previous_trial"
      },
    { -- Keybind to switch to the next trial
        ["setting_id"] = "cs_next_trial_keybind",
        ["type"] = "keybind",
        ["keybind_trigger"] = "pressed",
        ["keybind_type"] = "function_call",
        ["default_value"] = {},
        ["function_name"] = "next_trial"
    },
  }
}

return mod_data
