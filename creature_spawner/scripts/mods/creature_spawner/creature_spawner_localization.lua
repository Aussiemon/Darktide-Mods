--[[
  text_id = {
    en        = "<English>",
    fr        = "<French>",
    de        = "<German>",
    es        = "<Spanish>",
    ru        = "<Russian>",
    it        = "<Italian>",
    pl        = "<Polish>",
    ["br-pt"] = "<Portuguese-Brazil>",
  }
--]]

return {
  mod_name = {
    en = "Creature Spawner",
  },
  mod_description = {
    en = "Allows you to spawn various units in self-hosted maps that support them.",
  },
  cs_unit_list = {
    en = "Available Unit List",
  },
  cs_unit_list_description = {
    en = "Allows choosing which units are available to spawn.\n" ..
    "-- REGULAR --\nAll 'normal' unit types.\n" ..
    "-- ELITE --\nOnly regular elite units.\n" ..
    "-- SPECIAL --\nOnly regular specialist units.\n" ..
    "-- BOSS --\nAll bosses and monstrosities.\n" ..
    "-- MISC --\nUnused, unstable, or debug units.\n" ..
    "-- ALL --\nAll known units.",
  },
  cs_unit_list_header_regular = {
    en = "Regular",
  },
  cs_unit_list_header_regular_description = {
    en = "All 'normal' unit types.",
  },
  cs_unit_list_header_elite = {
    en = "Elite",
  },
  cs_unit_list_header_elite_description = {
    en = "Only regular elite units.",
  },
  cs_unit_list_header_specialist = {
    en = "Specialist",
  },
  cs_unit_list_header_specialist_description = {
    en = "Only regular specialist units.",
  },
  cs_unit_list_header_boss = {
    en = "Boss",
  },
  cs_unit_list_header_boss_description = {
    en = "All bosses and monstrosities",
  },
  cs_unit_list_header_misc = {
    en = "Misc",
  },
  cs_unit_list_header_misc_description = {
    en = "Unused, unstable, or debug units.",
  },
  cs_unit_list_header_all = {
    en = "All",
  },
  cs_unit_list_header_all_description = {
    en = "All known units",
  },
  cs_unit_side = {
    en = "Unit Team / Side",
  },
  cs_unit_side_description = {
    en = "Allows choosing the side that units spawn on.\n" ..
    "-- HEROES --\nThe side of the players.\n" ..
    "-- VILLAINS --\nThe side of the enemy."
  },
  cs_unit_side_header_heroes = {
    en = "Heroes",
  },
  cs_unit_side_header_heroes_description = {
    en = "The side of the players.",
  },
  cs_unit_side_header_villains = {
    en = "Villains",
  },
  cs_unit_side_header_villains_description = {
    en = "The side of the enemy.",
  },
  cs_spawn_keybind = {
    en = "Keybind: Spawn Unit",
  },
  cs_spawn_keybind_description = {
    en = "Choose the keybinding that spawns a unit.",
  },
  cs_next_keybind = {
    en = "Keybind: Next Unit",
  },
  cs_next_keybind_description = {
    en = "Choose the keybinding that selects the next unit.",
  },
  cs_prev_keybind = {
    en = "Keybind: Previous Unit",
  },
  cs_prev_keybind_description = {
    en = "Choose the keybinding that selects the previous unit.",
  },
  cs_destroy_keybind = {
    en = "Keybind: Destroy All Units",
  },
  cs_destroy_keybind_description = {
    en = "Choose the keybinding that destroys all units in the Training Grounds.",
  },
  cs_spawn_saved_unit_one_keybind = {
    en = "Keybind: Spawn Saved Unit One",
  },
  cs_spawn_saved_unit_one_keybind_description = {
    en = "Choose the keybinding that spawns the first saved unit.",
  },
  cs_spawn_saved_unit_two_keybind = {
    en = "Keybind: Spawn Saved Unit Two",
  },
  cs_spawn_saved_unit_two_keybind_description = {
    en = "Choose the keybinding that spawns the second saved unit.",
  },
  cs_spawn_saved_unit_three_keybind = {
    en = "Keybind: Spawn Saved Unit Three",
  },
  cs_spawn_saved_unit_three_keybind_description = {
    en = "Choose the keybinding that spawns the third saved unit.",
  },
  cs_enable_training_grounds_invisibility = {
    en = "Enable Invisibility in Training Grounds",
  },
  cs_enable_training_grounds_invisibility_description = {
    en = "Toggle Player Invisibility in the Training Grounds on / off.",
  },
  cs_enable_training_grounds_respawn = {
    en = "Enable AI Respawn in Training Grounds",
  },
  cs_enable_training_grounds_respawn_description = {
    en = "Toggle automatic AI respawn in the Training Grounds on / off.",
  },
  cs_enable_training_grounds_sound_muffler = {
    en = "Enable Sound Muffler in Training Grounds",
  },
  cs_enable_training_grounds_sound_muffler_description = {
    en = "Toggle vanilla sound muffler in the Training Grounds on / off.",
  },
  cs_enable_training_grounds_invulnerability = {
    en = "Enable Invulnerability in Training Grounds",
  },
  cs_enable_training_grounds_invulnerability_description = {
    en = "Toggle Player Invulnerability in the Training Grounds on / off.",
  },
  cs_heal_player_keybind = {
    en = "Keybind: Heal Player",
  },
  cs_heal_player_keybind_description = {
    en = "Choose the keybinding that heals the player in the Training Grounds.",
  },
  cs_add_toughness_keybind = {
    en = "Keybind: Add Toughness",
  },
  cs_add_toughness_keybind_description = {
    en = "Choose the keybinding that adds toughness to the player in the Training Grounds.",
  },
  cs_assist_player_keybind = {
    en = "Keybind: Assist Player",
  },
  cs_assist_player_keybind_description = {
    en = "Choose the keybinding that gets the player out of a disabled state in the Training Grounds.",
  },
}
