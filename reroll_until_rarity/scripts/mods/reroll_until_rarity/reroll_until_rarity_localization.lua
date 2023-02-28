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
    en = "Reroll-Until-Rarity",
    ["zh-cn"] = "连续重抽到指定等级",
  },
  mod_description = {
    en = "Automatically reroll perks until the desired rarity is reached.\n" ..
    "Does not consider reroll costs, so best to use when rerolls are free.",
    ["zh-cn"] = "自动重抽专长，直到达到所需的等级。\n" ..
    "不会考虑重抽费用，所以最好等重抽免费再使用。",
  },
  rur_desired_rarity = {
    en = "Desired Rarity",
    ["zh-cn"] = "所需等级",
  },
  rur_desired_rarity_description = {
    en = "Will stop rerolling if this rarity is reached.",
    ["zh-cn"] = "专长达到此等级后，停止重抽。",
  },
  rur_max_attempts = {
    en = "Max Attempts",
    ["zh-cn"] = "最大尝试次数",
  },
  rur_max_attempts_description = {
    en = "Will stop rerolling if this number of attempts is reached.",
    ["zh-cn"] = "达到此尝试次数后，停止重抽。",
  },
  rur_cancel_keybind = {
    en = "Keybind: Cancel Reroll",
    ["zh-cn"] = "快捷键：取消重抽",
  },
  rur_cancel_keybind_description = {
    en = "Keybind to cancel automatic rerolling mid-operation.",
    ["zh-cn"] = "用于中途取消自动重抽的按键。",
  },
}
