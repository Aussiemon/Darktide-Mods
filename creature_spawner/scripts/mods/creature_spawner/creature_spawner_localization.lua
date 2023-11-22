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
    ["zh-cn"] = "生物生成",
  },
  mod_description = {
    en = "Allows you to spawn various units in self-hosted maps that support them.",
    ["zh-cn"] = "允许你在自己主办的游戏中生成各种单位。",
  },
  cs_unit_list = {
    en = "Available Unit List",
    ["zh-cn"] = "可用单位列表",
  },
  cs_unit_list_description = {
    en = "Allows choosing which units are available to spawn.\n" ..
    "-- REGULAR --\nAll 'normal' unit types.\n" ..
    "-- ELITE --\nOnly regular elite units.\n" ..
    "-- SPECIAL --\nOnly regular specialist units.\n" ..
    "-- BOSS --\nAll bosses and monstrosities.\n" ..
    "-- MISC --\nUnused, unstable, or debug units.\n" ..
    "-- ALL --\nAll known units.",
    ["zh-cn"] = "允许选择可以生成的单位。\n" ..
    "-- 常规 --\n所有普通单位类型。\n" ..
    "-- 精英 --\n仅常规精英单位。\n" ..
    "-- 专家 --\n仅常规专家单位。\n" ..
    "-- Boss --\n所有 Boss 和怪物。\n" ..
    "-- 杂项 --\n未使用、不稳定或调试的单位。\n" ..
    "-- 所有 --\n所有已知单位。",
  },
  cs_unit_list_header_regular = {
    en = "Regular",
    ["zh-cn"] = "常规",
  },
  cs_unit_list_header_regular_description = {
    en = "All 'normal' unit types.",
    ["zh-cn"] = "所有普通单位类型。",
  },
  cs_unit_list_header_elite = {
    en = "Elite",
    ["zh-cn"] = "精英",
  },
  cs_unit_list_header_elite_description = {
    en = "Only regular elite units.",
    ["zh-cn"] = "仅常规精英单位。",
  },
  cs_unit_list_header_specialist = {
    en = "Specialist",
    ["zh-cn"] = "专家",
  },
  cs_unit_list_header_specialist_description = {
    en = "Only regular specialist units.",
    ["zh-cn"] = "仅常规专家单位。",
  },
  cs_unit_list_header_boss = {
    en = "Boss",
    ["zh-cn"] = "Boss",
  },
  cs_unit_list_header_boss_description = {
    en = "All bosses and monstrosities",
    ["zh-cn"] = "所有 Boss 和怪物。",
  },
  cs_unit_list_header_misc = {
    en = "Misc",
    ["zh-cn"] = "杂项",
  },
  cs_unit_list_header_misc_description = {
    en = "Unused, unstable, or debug units.",
    ["zh-cn"] = "未使用、不稳定或调试的单位。",
  },
  cs_unit_list_header_all = {
    en = "All",
    ["zh-cn"] = "所有",
  },
  cs_unit_list_header_all_description = {
    en = "All known units",
    ["zh-cn"] = "所有已知单位。",
  },
  cs_unit_side = {
    en = "Unit Team / Side",
    ["zh-cn"] = "单位团队 / 阵营",
  },
  cs_unit_side_description = {
    en = "Allows choosing the side that units spawn on.\n" ..
    "-- HEROES --\nThe side of the players.\n" ..
    "-- VILLAINS --\nThe side of the enemy.",
    ["zh-cn"] = "允许选择生成单位的阵营。\n" ..
    "-- 特工 --\n玩家一方阵营。\n" ..
    "-- 反派 --\n敌人一方阵营。",
  },
  cs_unit_side_header_heroes = {
    en = "Heroes",
    ["zh-cn"] = "特工",
  },
  cs_unit_side_header_heroes_description = {
    en = "The side of the players.",
    ["zh-cn"] = "玩家一方阵营。",
  },
  cs_unit_side_header_villains = {
    en = "Villains",
    ["zh-cn"] = "反派",
  },
  cs_unit_side_header_villains_description = {
    en = "The side of the enemy.",
    ["zh-cn"] = "敌人一方阵营。",
  },
  cs_spawn_keybind = {
    en = "Keybind: Spawn Unit",
    ["zh-cn"] = "快捷键：生成单位",
  },
  cs_spawn_keybind_description = {
    en = "Choose the keybinding that spawns a unit.",
    ["zh-cn"] = "选择用于生成单位的按键。",
  },
  cs_next_keybind = {
    en = "Keybind: Next Unit",
    ["zh-cn"] = "快捷键：下一个单位",
  },
  cs_next_keybind_description = {
    en = "Choose the keybinding that selects the next unit.",
    ["zh-cn"] = "选择用于选择下一个单位的按键。",
  },
  cs_prev_keybind = {
    en = "Keybind: Previous Unit",
    ["zh-cn"] = "快捷键：上一个单位",
  },
  cs_prev_keybind_description = {
    en = "Choose the keybinding that selects the previous unit.",
    ["zh-cn"] = "选择用于选择上一个单位的按键。",
  },
  cs_destroy_keybind = {
    en = "Keybind: Destroy All Units",
    ["zh-cn"] = "快捷键：删除所有单位",
  },
  cs_destroy_keybind_description = {
    en = "Choose the keybinding that destroys all units in the Training Grounds.",
    ["zh-cn"] = "选择用于删除训练场内所有单位的按键。",
  },
  cs_spawn_saved_unit_one_keybind = {
    en = "Keybind: Spawn Saved Unit One",
    ["zh-cn"] = "快捷键：生成保存栏位 1 的单位",
  },
  cs_spawn_saved_unit_one_keybind_description = {
    en = "Choose the keybinding that spawns the first saved unit.",
    ["zh-cn"] = "选择用于生成第一个已保存单位的按键。",
  },
  cs_spawn_saved_unit_two_keybind = {
    en = "Keybind: Spawn Saved Unit Two",
    ["zh-cn"] = "快捷键：生成保存栏位 2 的单位",
  },
  cs_spawn_saved_unit_two_keybind_description = {
    en = "Choose the keybinding that spawns the second saved unit.",
    ["zh-cn"] = "选择用于生成第二个已保存单位的按键。",
  },
  cs_spawn_saved_unit_three_keybind = {
    en = "Keybind: Spawn Saved Unit Three",
    ["zh-cn"] = "快捷键：生成保存栏位 3 的单位",
  },
  cs_spawn_saved_unit_three_keybind_description = {
    en = "Choose the keybinding that spawns the third saved unit.",
    ["zh-cn"] = "选择用于生成第三个已保存单位的按键。",
  },
  cs_enable_training_grounds_invisibility = {
    en = "Enable Invisibility in Training Grounds",
    ["zh-cn"] = "在训练场内启用隐身",
  },
  cs_enable_training_grounds_invisibility_description = {
    en = "Toggle Player Invisibility in the Training Grounds on / off.",
    ["zh-cn"] = "开关玩家在训练场内是否可见。",
  },
  cs_enable_training_grounds_respawn = {
    en = "Enable AI Respawn in Training Grounds",
    ["zh-cn"] = "在训练场内启用 AI 复活",
  },
  cs_enable_training_grounds_respawn_description = {
    en = "Toggle automatic AI respawn in the Training Grounds on / off.",
    ["zh-cn"] = "开关 AI 是否在训练场内复活。",
  },
  cs_enable_training_grounds_sound_muffler = {
    en = "Enable Sound Muffler in Training Grounds",
    ["zh-cn"] = "在训练场内启用消音",
  },
  cs_enable_training_grounds_sound_muffler_description = {
    en = "Toggle vanilla sound muffler in the Training Grounds on / off.",
    ["zh-cn"] = "开关训练场内的自带消音。",
  },
  cs_enable_training_grounds_invulnerability = {
    en = "Enable Invulnerability in Training Grounds",
    ["zh-cn"] = "在训练场内启用无敌",
  },
  cs_enable_training_grounds_invulnerability_description = {
    en = "Toggle Player Invulnerability in the Training Grounds on / off.",
    ["zh-cn"] = "开关玩家在训练场内是否无敌。",
  },
  cs_heal_player_keybind = {
    en = "Keybind: Heal Player",
    ["zh-cn"] = "快捷键：治疗玩家",
  },
  cs_heal_player_keybind_description = {
    en = "Choose the keybinding that heals the player in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内治疗玩家的按键。",
  },
  cs_add_toughness_keybind = {
    en = "Keybind: Add Toughness",
    ["zh-cn"] = "快捷键：补充韧性",
  },
  cs_add_toughness_keybind_description = {
    en = "Choose the keybinding that adds toughness to the player in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内补充玩家韧性的按键。",
  },
  cs_assist_player_keybind = {
    en = "Keybind: Assist Player",
    ["zh-cn"] = "快捷键：协助玩家",
  },
  cs_assist_player_keybind_description = {
    en = "Choose the keybinding that gets the player out of a disabled state in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内解除玩家被控状态的按键。",
  },
  cs_enable_training_grounds_invisibility_keybind = {
    en = "Keybind: Toggle Player Invisibility"
  },
  cs_enable_training_grounds_invisibility_keybind_description = {
    en = "Choose the keybinding that toggles invisibility in the Training Grounds."
  },
  cs_enable_training_grounds_invulnerability_keybind = {
    en = "Keybind: Toggle Player Invulnerability"
  },
  cs_enable_training_grounds_invulnerability_keybind_description = {
    en = "Choose the keybinding that toggles invulnerability in the Training Grounds."
  },
}
