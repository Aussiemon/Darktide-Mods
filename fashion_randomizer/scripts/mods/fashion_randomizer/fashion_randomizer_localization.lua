local mod = get_mod("fashion_randomizer")

local localization_table = {
  mod_name = {
    en = "Fashion Randomizer",
  },
  fr_equip_keybind = {
    en = "Keybind: Randomize Items",
  },
  fr_equip_keybind_description = {
    en = "Keybind to randomize equipped items in self-hosted lobbies.",
  },
  fr_equip_command = {
    en = "equip",
  },
  fr_equip_command_description = {
    en = "Randomize your equipped items in self-hosted lobbies.",
  },
  fr_respect_archetypes = {
    en = "Respect Archetypes",
  },
  fr_respect_archetypes_description = {
    en = "Only equip items that match your character's archetype (e.g. Psyker, Zealot, Ogryn, Veteran).",
  },
  fr_slot_setting_prefix = {
    en = "Enable ",
  },
  fr_slot_setting_description_prefix = {
    en = "Toggle randomizing ",
  },
  fr_slot_setting_description_suffix = {
    en = " slot on/off.",
  },
}
localization_table.mod_description = {
  en = ("Use the /" ..
          localization_table.fr_equip_command.en ..
          " command to randomize your equipped items in self-hosted lobbies."),
}

local function format_slot_setting_name(slot_type, locale)
  return localization_table.fr_slot_setting_prefix[locale] .. (slot_type:gsub("^%l", string.upper))
end

local function format_slot_setting_description(slot_type, locale)
  return localization_table.fr_slot_setting_description_prefix[locale] ..
          string.trim(string.gsub(slot_type, "slot_", "")) ..
          localization_table.fr_slot_setting_description_suffix[locale]
end

mod.player_slots = {
  "slot_body_eye_color",
  "slot_body_face",
  "slot_body_face_hair",
  "slot_body_face_scar",
  "slot_body_face_tattoo",
  "slot_body_hair",
  "slot_body_hair_color",
  "slot_body_tattoo",
  "slot_body_torso",
  "slot_gear_extra_cosmetic",
  "slot_gear_head",
  "slot_gear_lowerbody",
  "slot_gear_upperbody",
  "slot_insignia",
  "slot_portrait_frame",
  "slot_primary",
  "slot_secondary"
}

mod.player_slots_setting_map = {}

-- Initialize settings and localizations for slots
for _, slot_type in ipairs(mod.player_slots) do
  local setting_name = "fr_enabled_" .. slot_type
  local setting_name_description = setting_name .. "_description"

  mod.player_slots_setting_map[slot_type] = setting_name

  localization_table[setting_name] = {}
  localization_table[setting_name_description] = {}

  for locale, _ in pairs(localization_table.fr_slot_setting_prefix) do
    localization_table[setting_name][locale] = format_slot_setting_name(slot_type, locale)
    localization_table[setting_name_description][locale] = format_slot_setting_description(slot_type, locale)
  end
end

return localization_table