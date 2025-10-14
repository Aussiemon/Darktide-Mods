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
    ru = "Спавнер существ",
    ["zh-tw"] = "怪物生成器",
  },
  mod_description = {
    en = "Allows you to spawn various units in self-hosted maps that support them.",
    ["zh-cn"] = "允许你在自己主办的游戏中生成各种单位。",
    ru = "Creature Spawner - Позволяет создавать на картах в частных играх различных существ, которые поддерживаются этими картами.",
    ["zh-tw"] = "允許你在私人遊戲的地圖中生成各種單位。",
  },
  cs_unit_list = {
    en = "Available Unit List",
    ["zh-cn"] = "可用单位列表",
    ru = "Список доступных существ",
    ["zh-tw"] = "可用單位列表",
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
    ru = "Позволяет выбирать, каких существ можно заспавнить.\n" ..
    "-- ОБЫЧНЫЕ --\nВсе «обычные» типы существ.\n" ..
    "-- ЭЛИТА --\nТолько элитные существа.\n" ..
    "-- СПЕЦИАЛИСТЫ --\nТолько специалисты.\n" ..
    "-- БОССЫ --\nВсе боссы и монстры.\n" ..
    "-- РАЗНОЕ --\nНеиспользуемые, нестабильные или отладочные существа.\n" ..
    "-- ВСЕ --\nВсе известные существа.",
    ["zh-tw"] = "允許選擇可生成的單位。\n" ..
    "-- 常規 --\n所有「普通」單位類型。\n" ..
    "-- 菁英 --\n僅限普通菁英單位。\n" ..
    "-- 專家 --\n僅限普通專家單位。\n" ..
    "-- Boss --\n所有 Boss 和怪物。\n" ..
    "-- 雜項 --\n未使用、不穩定或除錯用的單位。\n" ..
    "-- 全部 --\n所有已知單位。",
  },
  cs_unit_list_header_regular = {
    en = "Regular",
    ["zh-cn"] = "常规",
    ru = "Обычные",
    ["zh-tw"] = "常規",
  },
  cs_unit_list_header_regular_description = {
    en = "All 'normal' unit types.",
    ["zh-cn"] = "所有普通单位类型。",
    ru = "Все «обычные» типы существ",
    ["zh-tw"] = "所有「普通」單位類型。",
  },
  cs_unit_list_header_elite = {
    en = "Elite",
    ["zh-cn"] = "精英",
    ru = "Элита",
    ["zh-tw"] = "精英",
  },
  cs_unit_list_header_elite_description = {
    en = "Only regular elite units.",
    ["zh-cn"] = "仅常规精英单位。",
    ru = "Только обычные элитные существа.",
    ["zh-tw"] = "僅限普通精英單位。",
  },
  cs_unit_list_header_specialist = {
    en = "Specialist",
    ["zh-cn"] = "专家",
    ru = "Специалисты",
    ["zh-tw"] = "專家",
  },
  cs_unit_list_header_specialist_description = {
    en = "Only regular specialist units.",
    ["zh-cn"] = "仅常规专家单位。",
    ru = "Только обычные специалисты",
    ["zh-tw"] = "僅限普通專家單位。",
  },
  cs_unit_list_header_boss = {
    en = "Boss",
    ["zh-cn"] = "Boss",
    ru = "Боссы",
    ["zh-tw"] = "Boss",
  },
  cs_unit_list_header_boss_description = {
    en = "All bosses and monstrosities",
    ["zh-cn"] = "所有 Boss 和怪物。",
    ru = "Все боссы и монстры",
    ["zh-tw"] = "所有 Boss 和怪物。",
  },
  cs_unit_list_header_misc = {
    en = "Misc",
    ["zh-cn"] = "杂项",
    ru = "Разное",
    ["zh-tw"] = "雜項",
  },
  cs_unit_list_header_misc_description = {
    en = "Unused, unstable, or debug units.",
    ["zh-cn"] = "未使用、不稳定或调试的单位。",
    ru = "Неиспользуемые, нестабильные или отладочные существа.",
    ["zh-tw"] = "未使用、不穩定或除錯用的單位。",
  },
  cs_unit_list_header_all = {
    en = "All",
    ["zh-cn"] = "所有",
    ru = "Все",
  },
  cs_unit_list_header_all_description = {
    en = "All known units",
    ["zh-cn"] = "所有已知单位。",
    ru = "Все известные существа.",
    ["zh-tw"] = "所有已知單位。",
  },
  cs_unit_side = {
    en = "Unit Team / Side",
    ["zh-cn"] = "单位团队 / 阵营",
    ru = "Команда/сторона существа",
    ["zh-tw"] = "單位隊伍 / 陣營",
  },
  cs_unit_side_description = {
    en = "Allows choosing the side that units spawn on.\n" ..
    "-- HEROES --\nThe side of the players.\n" ..
    "-- VILLAINS --\nThe side of the enemy.",
    ["zh-cn"] = "允许选择生成单位的阵营。\n" ..
    "-- 特工 --\n玩家一方阵营。\n" ..
    "-- 反派 --\n敌人一方阵营。",
    ru = "Позволяет выбрать сторону, на которой появляется существо.\n" ..
    "-- ГЕРОИ --\nНа стороне игроков.\n" ..
    "-- ЗЛОДЕИ --\nНа стороне врага.",
    ["zh-tw"] = "允許選擇生成單位的陣營。\n" ..
    "-- 英雄 --\n玩家一方陣營。\n" ..
    "-- 反派 --\n敵人一方陣營。",
  },
  cs_unit_side_header_heroes = {
    en = "Heroes",
    ["zh-cn"] = "特工",
    ru = "Герои",
    ["zh-tw"] = "特工",
  },
  cs_unit_side_header_heroes_description = {
    en = "The side of the players.",
    ["zh-cn"] = "玩家一方阵营。",
    ru = "На стороне игроков.",
    ["zh-tw"] = "玩家陣營。",
  },
  cs_unit_side_header_villains = {
    en = "Villains",
    ["zh-cn"] = "反派",
    ru = "Злодеи",
    ["zh-tw"] = "反派",
  },
  cs_unit_side_header_villains_description = {
    en = "The side of the enemy.",
    ["zh-cn"] = "敌人一方阵营。",
    ru = "На стороне врага.",
    ["zh-tw"] = "敵方陣營。",
  },
  cs_spawn_keybind = {
    en = "Keybind: Spawn Unit",
    ["zh-cn"] = "快捷键：生成单位",
    ru = "Клавиша: Заспавнить существо",
    ["zh-tw"] = "快捷鍵：生成單位",
  },
  cs_spawn_keybind_description = {
    en = "Choose the keybinding that spawns a unit.",
    ["zh-cn"] = "选择用于生成单位的按键。",
    ru = "Выберите комбинацию клавиш или клавишу, нажатие на которую заспавнит существо.",
    ["zh-tw"] = "選擇用於生成單位的快捷鍵。",
  },
  cs_next_keybind = {
    en = "Keybind: Next Unit",
    ["zh-cn"] = "快捷键：下一个单位",
    ru = "Клавиша: Следующее существо",
    ["zh-tw"] = "快捷鍵：下一個單位",
  },
  cs_next_keybind_description = {
    en = "Choose the keybinding that selects the next unit.",
    ["zh-cn"] = "选择用于选择下一个单位的按键。",
    ru = "Выберите комбинацию клавиш или клавишу для выбора следующего существа.",
    ["zh-tw"] = "選擇用於選擇下一個單位的快捷鍵。",
  },
  cs_prev_keybind = {
    en = "Keybind: Previous Unit",
    ["zh-cn"] = "快捷键：上一个单位",
    ru = "Клавиша: Предыдущее существо",
    ["zh-tw"] = "快捷鍵：上一個單位",
  },
  cs_prev_keybind_description = {
    en = "Choose the keybinding that selects the previous unit.",
    ["zh-cn"] = "选择用于选择上一个单位的按键。",
    ru = "Выберите комбинацию клавиш или клавишу для выбора предыдущего существа.",
    ["zh-tw"] = "選擇用於選擇上一個單位的快捷鍵。",
  },
  cs_destroy_keybind = {
    en = "Keybind: Destroy All Units",
    ["zh-cn"] = "快捷键：删除所有单位",
    ru = "Клавиша: Удалить всех существ",
    ["zh-tw"] = "快捷鍵：刪除所有單位",
  },
  cs_destroy_keybind_description = {
    en = "Choose the keybinding that destroys all units in the Training Grounds.",
    ["zh-cn"] = "选择用于删除训练场内所有单位的按键。",
    ru = "Выберите комбинацию клавиш или клавишу для удаления всех существ на Стрельбище.",
    ["zh-tw"] = "選擇用於刪除訓練場內所有單位的快捷鍵。",
  },
  cs_spawn_saved_unit_one_keybind = {
    en = "Keybind: Spawn Saved Unit One",
    ["zh-cn"] = "快捷键：生成保存栏位 1 的单位",
    ru = "Клавиша: Заспавнить сохранённое существо 1",
    ["zh-tw"] = "快捷鍵：生成儲存欄位 1 的單位",
  },
  cs_spawn_saved_unit_one_keybind_description = {
    en = "Choose the keybinding that spawns the first saved unit.",
    ["zh-cn"] = "选择用于生成第一个已保存单位的按键。",
    ru = "Выберите комбинацию клавиш или клавишу для спавна первого сохранённого существа.",
    ["zh-tw"] = "選擇用於生成第一個已儲存單位的快捷鍵。",
  },
  cs_spawn_saved_unit_two_keybind = {
    en = "Keybind: Spawn Saved Unit Two",
    ["zh-cn"] = "快捷键：生成保存栏位 2 的单位",
    ru = "Клавиша: Заспавнить сохранённое существо 2",
    ["zh-tw"] = "快捷鍵：生成儲存欄位 2 的單位",
  },
  cs_spawn_saved_unit_two_keybind_description = {
    en = "Choose the keybinding that spawns the second saved unit.",
    ["zh-cn"] = "选择用于生成第二个已保存单位的按键。",
    ru = "Выберите комбинацию клавиш или клавишу для спавна второго сохранённого существа.",
    ["zh-tw"] = "選擇用於生成第二個已儲存單位的快捷鍵。",
  },
  cs_spawn_saved_unit_three_keybind = {
    en = "Keybind: Spawn Saved Unit Three",
    ["zh-cn"] = "快捷键：生成保存栏位 3 的单位",
    ru = "Клавиша: Заспавнить сохранённое существо 3",
    ["zh-tw"] = "快捷鍵：生成儲存欄位 3 的單位",
  },
  cs_spawn_saved_unit_three_keybind_description = {
    en = "Choose the keybinding that spawns the third saved unit.",
    ["zh-cn"] = "选择用于生成第三个已保存单位的按键。",
    ru = "Выберите комбинацию клавиш или клавишу для спавна третьего сохранённого существа.",
    ["zh-tw"] = "選擇用於生成第三個已儲存單位的快捷鍵。",
  },
  cs_enable_training_grounds_invisibility = {
    en = "Enable Invisibility in Training Grounds",
    ["zh-cn"] = "在训练场内启用隐身",
    ru = "Включить невидимость на Стрельбище",
    ["zh-tw"] = "在訓練場中啟用隱身",
  },
  cs_enable_training_grounds_invisibility_description = {
    en = "Toggle Player Invisibility in the Training Grounds on / off.",
    ["zh-cn"] = "开关玩家在训练场内是否可见。",
    ru = "Включить/выключить невидимость игрока на Стрельбище.",
    ["zh-tw"] = "切換玩家在訓練場中的隱身狀態。",
  },
  cs_enable_training_grounds_respawn = {
    en = "Enable AI Respawn in Training Grounds",
    ["zh-cn"] = "在训练场内启用 AI 复活",
    ru = "Включить респавн ИИ врагов на Стрельбище",
    ["zh-tw"] = "在訓練場中啟用 AI 重生",
  },
  cs_enable_training_grounds_respawn_description = {
    en = "Toggle automatic AI respawn in the Training Grounds on / off.",
    ["zh-cn"] = "开关 AI 是否在训练场内复活。",
    ru = "Включить/выключить автоматический респавн ИИ врагов на Стрельбище.",
    ["zh-tw"] = "切換訓練場中 AI 是否自動重生。",
  },
  cs_enable_training_grounds_sound_muffler = {
    en = "Enable Sound Muffler in Training Grounds",
    ["zh-cn"] = "在训练场内启用消音",
    ru = "Заглушить звуки существ на Стрельбище",
    ["zh-tw"] = "在訓練場中啟用消音功能",
  },
  cs_enable_training_grounds_sound_muffler_description = {
    en = "Toggle vanilla sound muffler in the Training Grounds on / off.",
    ["zh-cn"] = "开关训练场内的自带消音。",
    ru = "Включить/выключить стандартный глушитель звука существ на Стрельбище.",
    ["zh-tw"] = "切換訓練場中的原生消音功能。",
  },
  cs_enable_training_grounds_invulnerability = {
    en = "Enable Invulnerability in Training Grounds",
    ["zh-cn"] = "在训练场内启用无敌",
    ru = "Включить неуязвимость на Стрельбище",
    ["zh-tw"] = "在訓練場中啟用無敵",
  },
  cs_enable_training_grounds_invulnerability_description = {
    en = "Toggle Player Invulnerability in the Training Grounds on / off.",
    ["zh-cn"] = "开关玩家在训练场内是否无敌。",
    ru = "Включить/выключить неуязвимость игрока на Стрельбище.",
    ["zh-tw"] = "切換玩家在訓練場中的無敵狀態。",
  },
  cs_heal_player_keybind = {
    en = "Keybind: Heal Player",
    ["zh-cn"] = "快捷键：治疗玩家",
    ru = "Клавиша: Вылечить игрока",
    ["zh-tw"] = "快捷鍵：治療玩家",
  },
  cs_heal_player_keybind_description = {
    en = "Choose the keybinding that heals the player in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内治疗玩家的按键。",
    ru = "Выберите комбинацию клавиш или клавишу, при нажатии на которую игрок будет вылечен на Стрельбище.",
    ["zh-tw"] = "選擇用於在訓練場中治療玩家的快捷鍵。",
  },
  cs_add_toughness_keybind = {
    en = "Keybind: Add Toughness",
    ["zh-cn"] = "快捷键：补充韧性",
    ru = "Клавиша: Добавить Стойкость",
    ["zh-tw"] = "快捷鍵：補充韌性",
  },
  cs_add_toughness_keybind_description = {
    en = "Choose the keybinding that adds toughness to the player in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内补充玩家韧性的按键。",
    ru = "Выберите комбинацию клавиш или клавишу, при нажатии на которую игроку будет добавлена Стойкость на Стрельбище.",
    ["zh-tw"] = "選擇用於在訓練場中補充玩家韌性的快捷鍵。",
  },
  cs_assist_player_keybind = {
    en = "Keybind: Assist Player",
    ["zh-cn"] = "快捷键：协助玩家",
    ru = "Клавиша: Помощь игроку",
    ["zh-tw"] = "快捷鍵：協助玩家",
  },
  cs_assist_player_keybind_description = {
    en = "Choose the keybinding that gets the player out of a disabled state in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内解除玩家被控状态的按键。",
    ru = "Выберите комбинацию клавиш или клавишу, при нажатии на которую игрок будет поднят, если он выведен из строя на Стрельбище.",
    ["zh-tw"] = "選擇用於在訓練場中解除玩家被控狀態的快捷鍵。",
  },
  cs_reset_combat_ability_cooldown_keybind = {
    en = "Keybind: Reset Combat Ability Cooldown",
    ["zh-cn"] = "快捷键：重置主动技能冷却",
    ru = "Клавиша: Cброс времени восстановления боевых способностей",
    ["zh-tw"] = "快捷鍵：重置戰鬥技能冷卻時間",
  },
  cs_reset_combat_ability_cooldown_keybind_description = {
    en = "Choose the keybinding that resets the Combat Ability Cooldown in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内重置主动技能冷却的快捷键。",
    ru = "Выберите комбинацию клавиш, которая сбрасывает время восстановления боевых способностей на Стрельбище.",
    ["zh-tw"] = "選擇用於在訓練場中重置戰鬥技能冷卻時間的快捷鍵。",
  },
  cs_enable_training_grounds_invisibility_keybind = {
    en = "Keybind: Toggle Player Invisibility",
    ["zh-cn"] = "快捷键：开关玩家隐身",
    ru = "Клавиша: Переключить невидимость игрока",
    ["zh-tw"] = "快捷鍵：切換玩家隱身",
  },
  cs_enable_training_grounds_invisibility_keybind_description = {
    en = "Choose the keybinding that toggles invisibility in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内开关玩家隐身的快捷键。",
    ru = "Выберите сочетание клавиш, которое включает невидимость на Стрельбище.",
    ["zh-tw"] = "選擇用於在訓練場中切換玩家隱身的快捷鍵。",
  },
  cs_enable_training_grounds_invulnerability_keybind = {
    en = "Keybind: Toggle Player Invulnerability",
    ["zh-cn"] = "快捷键：开关玩家无敌",
    ru = "Клавиша: Переключить неуязвимость игрока",
    ["zh-tw"] = "快捷鍵：切換玩家無敵",
  },
  cs_enable_training_grounds_invulnerability_keybind_description = {
    en = "Choose the keybinding that toggles invulnerability in the Training Grounds.",
    ["zh-cn"] = "选择用于在训练场内开关玩家无敌的快捷键。",
    ru = "Выберите сочетание клавиш, которое включает неуязвимость на Стрельбище.",
    ["zh-tw"] = "選擇用於在訓練場中切換玩家無敵的快捷鍵。",
  },
  cs_active_trial = {
    en = "Current Trial",
    ["zh-cn"] = "当前试炼",
    ru = "Текущее испытание",
    ["zh-tw"] = "當前試煉",
  },
  cs_active_trial_description = {
    en = "Choose the current Training Grounds trial. None will result in regular Training Grounds spawns.",
    ["zh-cn"] = "选择当前的训练场试炼。选择 None 则会生成标准怪物。",
    ru = "Выберите текущее испытание на Стрельбище. Ни одно из них не приведёт к периодическому спавну врагов на Стрельбище.",
    ["zh-tw"] = "選擇當前的訓練場試煉。選擇 None 則會生成標準怪物。",
  },
  cs_previous_trial_keybind = {
    en = "Keybind: Previous Trial",
    ["zh-cn"] = "快捷键：上一个试炼",
    ru = "Клавиша: Предыдущее испытание",
    ["zh-tw"] = "快捷鍵：上一個試煉",
  },
  cs_previous_trial_keybind_description = {
    en = "Cycles backward through potential trials.",
    ["zh-cn"] = "切换到上一个可用的试炼",
    ru = "Переключает на предыдущее испытание.",
    ["zh-tw"] = "切換到上一個可用的試煉。",
  },
  cs_next_trial_keybind = {
    en = "Keybind: Next Trial",
    ["zh-cn"] = "快捷键：下一个试炼",
    ru = "Клавиша: Следующее испытание",
    ["zh-tw"] = "快捷鍵：下一個試煉",
  },
  cs_next_trial_keybind_description = {
    en = "Cycles through potential trials.",
    ["zh-cn"] = "切换到下一个可用的试炼",
    ru = "Переключает на следующее испытание.",
    ["zh-tw"] = "切換到下一個可用的試煉。",
  },
}
