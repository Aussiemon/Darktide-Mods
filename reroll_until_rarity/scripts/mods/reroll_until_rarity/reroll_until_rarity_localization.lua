local mod = get_mod("reroll_until_rarity")

local localization_table = {
  mod_name = {
    en = "Reroll-Until-Rarity",
    ["zh-cn"] = "自动重抽专长",
  },
  mod_description = {
    en = "Automatically reroll perks until the desired rarity and perk are reached.\n" ..
    "Does not consider reroll costs, so best used when rerolls are free.",
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
  rur_enable_selected_perk = {
    en = "Wait for Desired Perk",
    ["zh-cn"] = "等待指定专长",
  },
  rur_enable_selected_perk_description = {
    en = "Toggle on/off to reroll until the desired perk is obtained.",
    ["zh-cn"] = "开关是否等获取到指定专长才停止重抽。",
  },
  rur_selected_perk = {
    en = "Desired Perk",
    ["zh-cn"] = "指定专长",
  },
  rur_selected_perk_description = {
    en = "Select the desired perk. "
         .. "NOTE: The selected perk might not be available for the item you're rerolling. "
         .. "Reopen the reroll screen after updating.",
    ["zh-cn"] = "选择指定专长。"
         .. "注意：这里选择的专长可能对重抽的物品无效。"
         .. "修改此选项后请重新打开精炼界面。",
  },
  rur_any_perk = {
    en = "Any Perk",
    ["zh-cn"] = "任意专长",
  },
  rur_any_perk_description = {
    en = "Select no specific perk.",
    ["zh-cn"] = "不指定任何专长。",
  },
  rur_hush_hadron = {
    en = "Mute Hadron",
    ["zh-cn"] = "禁言海德昂",
  },
  rur_hush_hadron_description = {
    en = "Disable Hadron VO commentary while crafting.",
    ["zh-cn"] = "合成时禁用海德昂的对话。",
  },
}

local ItemUtils = require("scripts/utilities/items")

local safe_format = function(str)
  local new_str = string.trim(string.gsub(str, "[%%%+0-9%.]", ""))
  new_str = string.trim(string.gsub(new_str, "Melee%s", ""))
  new_str = string.trim(string.gsub(new_str, "Ranged%s", ""))

  return new_str
end

local space_to_underscore = function(str)
  return string.trim(string.gsub(str, "[%s]+", "_"))
end

local perk_blacklist = {
  ["Damage"] = true,
  ["NEW Perk"] = true,
}

mod.perk_descriptions = {}

-- MasterItems isn't populated at startup right now, so this is disabled.
--local MasterItems = require("scripts/backend/master_items")
--local item_cache = MasterItems and MasterItems.get_cached()

-- table.insert(filtered_item_cache, {
--   item_type = item.item_type,
--   trait = item.trait,
--   description = item.description,
--   description_values = item.description_values,
-- })

-- Perk items as of 03/12/2023
local item_cache = {
  {
    ["description_values"] = {
      {
        ["string_value"] = "4%",
        ["string_key"] = "mission_reward_xp_modifier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "mission_reward_xp_modifier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "2%",
        ["string_key"] = "mission_reward_xp_modifier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "6%",
        ["string_key"] = "mission_reward_xp_modifier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_mission_xp_increase",
    ["description"] = "loc_trait_gadget_mission_xp_increase_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "weakspot_damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "weakspot_damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "weakspot_damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "weakspot_damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_weakspot_damage",
    ["description"] = "loc_trait_melee_common_wield_increase_weakspot_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_common_wield_increased_disgustingly_resilient_damage",
    ["description"] = "loc_trait_ranged_common_wield_disgustinglyresilient_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_damage_reduction_vs_hounds",
    ["description"] = "loc_trait_gadget_dr_vs_hounds_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "crit_damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "crit_damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "crit_damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "crit_damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_crit_damage",
    ["description"] = "loc_trait_ranged_common_wield_wield_increase_critical_strike_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_melee_common_wield_increased_super_armor_damage",
    ["description"] = "loc_trait_melee_common_wield_increased_super_armor_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "toughness_regen_delay_multiplier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "30%",
        ["string_key"] = "toughness_regen_delay_multiplier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "7.5%",
        ["string_key"] = "toughness_regen_delay_multiplier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "22.5%",
        ["string_key"] = "toughness_regen_delay_multiplier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_toughness_regen_delay",
    ["description"] = "loc_gadget_toughness_regen_delay_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_melee_common_wield_increased_disgustingly_resilient_damage",
    ["description"] = "loc_trait_melee_common_wield_increased_disgustingly_resilient_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "reduced_block_cost",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "reduced_block_cost",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "reduced_block_cost",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "reduced_block_cost",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_reduced_block_cost",
    ["description"] = "loc_trait_melee_common_wield_reduce_block_cost_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_common_wield_increased_unarmored_damage",
    ["description"] = "loc_trait_ranged_common_wield_unarmored_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_common_wield_increased_super_armor_damage",
    ["description"] = "loc_trait_ranged_common_wield_superarmor_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_reduce_sprint_cost",
    ["description"] = "loc_gadget_sprint_cost_reduction_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "gadget_inate_toughness_increase",
    ["description"] = "loc_inate_gadget_toughness_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "",
    ["description"] = "loc_crafting_upgrade_unknown_perk_description"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_common_wield_increased_armored_damage",
    ["description"] = "loc_trait_ranged_common_wield_armored_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_damage_specials",
    ["description"] = "loc_trait_ranged_common_wield_increase_special_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "1",
        ["string_key"] = "stamina",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "1",
        ["string_key"] = "stamina",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1",
        ["string_key"] = "stamina",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "1",
        ["string_key"] = "stamina",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_stamina",
    ["description"] = "loc_trait_melee_common_wield_increase_stamina_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "gadget_stamina_increase",
    ["description"] = "loc_inate_gadget_stamina_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "2%",
        ["string_key"] = "power_mod",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "power_mod",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1%",
        ["string_key"] = "power_mod",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "3%",
        ["string_key"] = "power_mod",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_power",
    ["description"] = "loc_trait_ranged_common_wield_increase_power_modifier_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "8%",
        ["string_key"] = "block_cost_multiplier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "12%",
        ["string_key"] = "block_cost_multiplier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "6%",
        ["string_key"] = "block_cost_multiplier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "block_cost_multiplier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_block_cost_reduction",
    ["description"] = "loc_gadget_block_cost_reduction_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "9%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "6%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "12%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_sprint_cost_reduction",
    ["description"] = "loc_gadget_sprint_cost_reduction_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "3%",
        ["string_key"] = "max_health_modifier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "max_health_modifier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "2%",
        ["string_key"] = "max_health_modifier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "max_health_modifier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_health_increase",
    ["description"] = "loc_trait_gadget_health_increase_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "sprinting_cost_multiplier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_reduce_sprint_cost",
    ["description"] = "loc_gadget_sprint_cost_reduction_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_melee_common_wield_increased_berserker_damage",
    ["description"] = "loc_trait_melee_common_wield_increased_berserker_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_damage_specials",
    ["description"] = "loc_trait_melee_common_wield_increase_special_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "3%",
        ["string_key"] = "attack_speed",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "attack_speed",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "2%",
        ["string_key"] = "attack_speed",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "attack_speed",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "",
    ["description"] = "loc_trait_melee_common_wield_increase_attack_speed_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_damage_reduction_vs_mutants",
    ["description"] = "loc_trait_gadget_dr_vs_mutants_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "revive_speed_modifier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "revive_speed_modifier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "revive_speed_modifier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "revive_speed_modifier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_revive_speed_increase",
    ["description"] = "loc_gadget_revive_speed_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "mission_reward_credit_modifier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "mission_reward_credit_modifier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "mission_reward_credit_modifier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "mission_reward_credit_modifier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_mission_credits_increase",
    ["description"] = "loc_trait_gadget_mission_credits_increase_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "2%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "3%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_damage",
    ["description"] = "loc_trait_ranged_common_wield_increase_attack_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_melee_common_wield_increased_resistant_damage",
    ["description"] = "loc_trait_melee_common_wield_increased_resistant_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_damage_elites",
    ["description"] = "loc_trait_ranged_common_wield_increase_elite_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "2%",
        ["string_key"] = "finesse_modifier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "finesse_modifier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1%",
        ["string_key"] = "finesse_modifier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "3%",
        ["string_key"] = "finesse_modifier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_finesse",
    ["description"] = "loc_trait_ranged_common_wield_increase_finesse_modifier_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "gadget_inate_max_wounds_increase",
    ["description"] = "loc_inate_gadget_health_segment_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "9%",
        ["string_key"] = "corruption_taken_multiplier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "corruption_taken_multiplier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "6%",
        ["string_key"] = "corruption_taken_multiplier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "12%",
        ["string_key"] = "corruption_taken_multiplier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_corruption_resistance",
    ["description"] = "loc_gadget_corruption_resistance_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_common_wield_increased_berserker_damage",
    ["description"] = "loc_trait_ranged_common_wield_berserker_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_damage_elites",
    ["description"] = "loc_trait_melee_common_wield_increase_elite_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "8%",
        ["string_key"] = "stamina_regeneration_modifier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "12%",
        ["string_key"] = "stamina_regeneration_modifier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "6%",
        ["string_key"] = "stamina_regeneration_modifier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "stamina_regeneration_modifier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_stamina_regeneration",
    ["description"] = "loc_gadget_stamina_regeneration_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_damage_reduction_vs_snipers",
    ["description"] = "loc_trait_gadget_dr_vs_snipers_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "",
    ["description"] = "loc_trait_ranged_common_wield_increase_roaming_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "1",
        ["string_key"] = "stamina",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "1",
        ["string_key"] = "stamina",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1",
        ["string_key"] = "stamina",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "1",
        ["string_key"] = "stamina",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_stamina",
    ["description"] = "loc_trait_ranged_common_wield_increase_stamina_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_common_wield_increased_resistant_damage",
    ["description"] = "loc_trait_ranged_common_wield_resistant_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "3%",
        ["string_key"] = "crit_chance",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "crit_chance",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "2%",
        ["string_key"] = "crit_chance",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "crit_chance",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_crit_chance",
    ["description"] = "loc_trait_melee_common_wield_increase_critical_hit_chance_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "impact_power",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "impact_power",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "impact_power",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "7%",
        ["string_key"] = "impact_power",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_impact",
    ["description"] = "loc_trait_melee_common_wield_increased_impact_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "2%",
        ["string_key"] = "ability_cooldown_modifier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "ability_cooldown_modifier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1%",
        ["string_key"] = "ability_cooldown_modifier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "3%",
        ["string_key"] = "ability_cooldown_modifier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_cooldown_reduction",
    ["description"] = "loc_gadget_cooldown_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "2%",
        ["string_key"] = "finesse_modifier",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "finesse_modifier",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1%",
        ["string_key"] = "finesse_modifier",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "3%",
        ["string_key"] = "finesse_modifier",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_finesse",
    ["description"] = "loc_trait_melee_common_wield_increase_finesse_modifier_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "2%",
        ["string_key"] = "power_mod",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "power_mod",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1%",
        ["string_key"] = "power_mod",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "3%",
        ["string_key"] = "power_mod",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_power",
    ["description"] = "loc_trait_melee_common_wield_increase_power_modifier_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "7%",
        ["string_key"] = "reload_speed",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "reload_speed",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "reload_speed",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8.5%",
        ["string_key"] = "reload_speed",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increased_reload_speed",
    ["description"] = "loc_trait_ranged_common_wield_increase_reload_speed_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_damage_reduction_vs_gunners",
    ["description"] = "loc_trait_gadget_dr_vs_gunners_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "3%",
        ["string_key"] = "toughness_bonus",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "toughness_bonus",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "2%",
        ["string_key"] = "toughness_bonus",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "toughness_bonus",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_toughness_increase",
    ["description"] = "loc_trait_gadget_toughness_increase_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_damage_reduction_vs_bombers",
    ["description"] = "loc_trait_gadget_dr_vs_bursters_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_damage_hordes",
    ["description"] = "loc_trait_melee_common_wield_increase_horde_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_melee_common_wield_increased_armored_damage",
    ["description"] = "loc_trait_melee_common_wield_increased_armored_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "crit_damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "crit_damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "crit_damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "crit_damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_crit_damage",
    ["description"] = "loc_trait_melee_common_wield_wield_increase_critical_strike_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_damage_reduction_vs_flamers",
    ["description"] = "loc_trait_gadget_dr_vs_flamer_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "25%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_melee_common_wield_increased_unarmored_damage",
    ["description"] = "loc_trait_melee_common_wield_increased_unarmored_damage_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "",
    ["description"] = "loc_trait_melee_common_wield_increase_monster_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "weakspot_damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "weakspot_damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "weakspot_damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "weakspot_damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_weakspot_damage",
    ["description"] = "loc_trait_ranged_common_wield_increase_weakspot_damage_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "",
    ["description"] = "loc_trait_ranged_common_wield_increase_monster_enemy_damage_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "gadget_inate_health_increase",
    ["description"] = "loc_inate_gadget_health_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "2%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "1%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "3%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_increase_damage",
    ["description"] = "loc_trait_melee_common_wield_increase_attack_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "3%",
        ["string_key"] = "crit_chance",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "crit_chance",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "2%",
        ["string_key"] = "crit_chance",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "crit_chance",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_crit_chance",
    ["description"] = "loc_trait_ranged_common_wield_increase_crit_chance_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "permanent_damage_converter_resistance",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "permanent_damage_converter_resistance",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "permanent_damage_converter_resistance",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "permanent_damage_converter_resistance",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "gadget_permanent_damage_resistance",
    ["description"] = "loc_gadget_grim_corruption_resistance_desc"
  },
  {
    ["description_values"] = {
    },
    ["trait"] = "",
    ["description"] = "loc_trait_melee_common_wield_increase_roaming_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "6%",
        ["string_key"] = "damage",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "4%",
        ["string_key"] = "damage",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "8%",
        ["string_key"] = "damage",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "weapon_trait_ranged_increase_damage_hordes",
    ["description"] = "loc_trait_ranged_common_wield_increase_horde_enemy_damage_desc"
  },
  {
    ["description_values"] = {
      {
        ["string_value"] = "10%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "2"
      },
      {
        ["string_value"] = "20%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "4"
      },
      {
        ["string_value"] = "5%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "1"
      },
      {
        ["string_value"] = "15%",
        ["string_key"] = "damage_reduction",
        ["rarity"] = "3"
      }
    },
    ["trait"] = "",
    ["description"] = "loc_trait_gadget_dr_vs_grenadiers_desc"
  }
}

-- Get all unique, localized perk descriptions.
local populate_perk_descriptions = function()
  if item_cache then
    for _, item in pairs(item_cache) do

      --if item and type(item) == "table" and item.item_type == "PERK" and item.description then
      if item and type(item) == "table" then

        -- We don't need any other localization, as the values will change with the game language
        local localized_description = safe_format(ItemUtils.perk_description(item, 1, 0))
        if localized_description
                    and not string.find(localized_description, "<")
                    and not perk_blacklist[localized_description] then

          local item_key = space_to_underscore(localized_description)
          mod.perk_descriptions[item_key] = localized_description
          localization_table[item_key] = {en = localized_description}
        end
      end
    end
  end
end
populate_perk_descriptions()

return localization_table
