local mod = get_mod("fancy_bots")

local localization_table = {
  mod_name = {
    en = "Fancy Bots",
    ["zh-cn"] = "酷炫机器人",
    ru = "Модные боты",
  },
  mod_description = {
    en = "Equip bots with proper or randomized gear. Client-side.",
    ["zh-cn"] = "给机器人装备合适或随机的装饰品。仅客户端可见。",
    ru = "Fancy Bots - Экипируйте ботов хорошим или случайным снаряжением. Видно только вам.",
  },
  fb_randomize = {
    en = "Randomize Gear",
    ["zh-cn"] = "随机装饰品",
    ru = "Случайный выбор снаряжения",
  },
  fb_randomize_description = {
    en = "Randomize bots' headgear, upperbody, and lowerbody.",
    ["zh-cn"] = "随机选择机器人的头部、上半身、下半身装饰品。",
    ru = "Случайный выбор головных уборов, верхней и нижней частей тела ботов.",
  },
  fb_slot_setting_prefix = {
    en = "Enable ",
    ["zh-cn"] = "启用 ",
    ru = "Включён ",
  },
  fb_slot_setting_description_prefix = {
    en = "Toggle replacement of ",
    ["zh-cn"] = "开关 ",
    ru = "Переключение замены ",
  },
  fb_slot_setting_description_suffix = {
    en = " slot on/off.",
    ["zh-cn"] = " 栏位的替换。",
    ru = " слот вкл/выкл",
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
