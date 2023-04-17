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
    en = "Bot Spawner",
    ["zh-cn"] = "机器人生成",
    ru = "Создание ботов",
  },
  mod_description = {
    en = "Spawn bots in self-hosted games with a hotkey.",
    ["zh-cn"] = "通过快捷键在自己主办的游戏中生成机器人。",
    ru = "Bot Spawner - Создавайте ботов с помощью горячих клавиш в играх, в которых вы являетесь хостом.",
  },
  next_bot_on_spawn = {
    en = "Switch Bots On Spawn",
    ["zh-cn"] = "生成时切换机器人档案",
    ru = "Переключать ботов при появлении",
  },
  next_bot_on_spawn_description = {
    en = "When a bot is spawned, switch to the next bot profile.",
    ["zh-cn"] = "当生成一个机器人时，切换到下一个机器人档案。",
    ru = "При появлении бота, переключается на следующий профиль бота.",
  },
  key_spawn_bot = {
    en = "Spawn Bot Hotkey",
    ["zh-cn"] = "生成机器人快捷键",
    ru = "Создать бота",
  },
  key_spawn_bot_description = {
    en = "The hotkey to spawn bots.",
    ["zh-cn"] = "用于生成机器人的按键。",
    ru = "Горячая клавиша для создания ботов.",
  },
  key_next_bot = {
    en = "Next Bot Hotkey",
    ["zh-cn"] = "下一个机器人快捷键",
    ru = "Следующий бот",
  },
  key_next_bot_description = {
    en = "The hotkey to switch to the next bot profile.",
    ["zh-cn"] = "用于切换到下一个机器人档案的按键。",
    ru = "Горячая клавиша для переключения на следующий профиль бота.",
  },
  key_despawn_bot = {
    en = "Despawn Bot Hotkey",
    ["zh-cn"] = "删除机器人快捷键",
    ru = "Удаление бота",
  },
  key_despawn_bot_description = {
    en = "The hotkey to despawn bots.",
    ["zh-cn"] = "用于删除机器人的按键。",
    ru = "Горячая клавиша для удаления бота.",
  },
  spawning_bot_text = {
    en = "Spawning bot: ",
    ["zh-cn"] = "生成机器人：",
    ru = "Появился бот: ",
  },
  next_bot_text = {
    en = "Switched to bot: ",
    ["zh-cn"] = "切换到机器人：",
    ru = "Сменился на бота: ",
  },
  despawning_bot_text = {
    en = "Despawning bot.",
    ["zh-cn"] = "删除机器人：",
    ru = "Бот удалён.",
  },
  error_delay_spawn_text = {
    en = "Please wait at least 2 seconds between spawning bots.",
    ["zh-cn"] = "请等待至少 2 秒再生成机器人。",
    ru = "Пожалуйста, подождите не менее 2 секунд перед созданием другого бота.",
  },
  error_profile_bot_text = {
    en = "Error spawning bot profile: ",
    ["zh-cn"] = "生成机器人档案错误：",
    ru = "Ошибка создания бота с профилем: ",
  },
  error_profiles_not_ready = {
    en = "Loading in progress. Bots are not yet ready to spawn.",
    ["zh-cn"] = "正在加载。现在还不能生成机器人。",
    ru = "Идет загрузка. Боты еще не готовы к созданию.",
  },
}
