local mod = get_mod("fancy_bots")

local localization_table = {
  mod_name = {
    en = "Fancy Bots",
  },
  mod_description = {
    en = "Equip bots with proper or randomized gear. Client-side.",
  },
  fb_randomize = {
    en = "Randomize Gear",
  },
  fb_randomize_description = {
    en = "Randomize bots' headgear, upperbody, and lowerbody.",
  },
  fb_slot_setting_prefix = {
    en = "Enable ",
  },
  fb_slot_setting_description_prefix = {
    en = "Toggle replacement of ",
  },
  fb_slot_setting_description_suffix = {
    en = " slot on/off.",
  },
}

local function format_slot_setting_name(slot_type, locale)
  return localization_table.fb_slot_setting_prefix[locale] .. (slot_type:gsub("^%l", string.upper))
end

local function format_slot_setting_description(slot_type, locale)
  return localization_table.fb_slot_setting_description_prefix[locale] ..
          string.trim(string.gsub(slot_type, "slot_", "")) ..
          localization_table.fb_slot_setting_description_suffix[locale]
end

mod.player_slots = {
  "slot_gear_head",
  "slot_gear_lowerbody",
  "slot_gear_upperbody",
}

mod.player_slots_setting_map = {}

-- Initialize settings and localizations for slots
for _, slot_type in ipairs(mod.player_slots) do
  local setting_name = "fb_enabled_" .. slot_type
  local setting_name_description = setting_name .. "_description"

  mod.player_slots_setting_map[slot_type] = setting_name

  localization_table[setting_name] = {}
  localization_table[setting_name_description] = {}

  for locale, _ in pairs(localization_table.fb_slot_setting_prefix) do
    localization_table[setting_name][locale] = format_slot_setting_name(slot_type, locale)
    localization_table[setting_name_description][locale] = format_slot_setting_description(slot_type, locale)
  end
end

return localization_table