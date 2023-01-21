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
  },
  mod_description = {
    en = "Automatically reroll perks until the desired rarity is reached.\n" ..
    "Does not consider reroll costs, so best to use when rerolls are free.",
  },
  rur_desired_rarity = {
    en = "Desired Rarity",
  },
  rur_desired_rarity_description = {
    en = "Will stop rerolling if this rarity is reached.",
  },
  rur_max_attempts = {
    en = "Max Attempts",
  },
  rur_max_attempts_description = {
    en = "Will stop rerolling if this number of attempts is reached.",
  },
  rur_cancel_keybind = {
    en = "Keybind: Cancel Reroll",
  },
  rur_cancel_keybind_description = {
    en = "Keybind to cancel automatic rerolling mid-operation.",
  },
}
