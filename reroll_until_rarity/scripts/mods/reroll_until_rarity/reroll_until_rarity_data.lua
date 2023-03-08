local mod = get_mod("reroll_until_rarity")

local mod_data = {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
}

-- All setting_id and dropdown text ids are automatically run through mod:localize()
mod_data.options = {
  widgets = {
    {
      setting_id      = "rur_desired_rarity",
      type            = "numeric",
      default_value   = 4,
      range           = {1, 4},
    },
    {
      setting_id      = "rur_max_attempts",
      type            = "numeric",
      default_value   = 10,
      range           = {1, 1000},
    },
    {
      setting_id      = "rur_cancel_keybind",
      type            = "keybind",
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      default_value   = {},
      function_name   = "cancel_operation"
    },
	  {
      setting_id      = "rur_desired_perk",
      type            = "dropdown",
      default_value   = "Any",
      options = {
        {text = "Any", value = "Any"},
        {text = "Toughness Regeneration Speed", value = "Toughness Regeneration Speed"},
        {text = "Block Efficiency", value = "Block Efficiency"},
        {text = "Stamina Regeneration", value = "Stamina Regeneration"},
        {text = "Health", value = "Health"},
        {text = "Toughness", value = "Toughness"},
        {text = "Combat Ability Regeneration", value = "Combat Ability Regeneration"},
        {text = "Corruption Resistance", value = "Corruption Resistance"},
        {text = "Damage Resistance (Gunners)", value = "Damage Resistance (Gunners)"},
        {text = "Damage Resistance (Snipers)", value = "Damage Resistance (Snipers)"},
        {text = "Stamina", value = "Stamina"},
        {text = "Critical Hit Chance", value = "Critical Hit Chance"},
        {text = "Critical Hit Damage", value = "Critical Hit Damage"},
        {text = "Flak", value = "Flak"},
        {text = "Carapace", value = "Carapace"},
        {text = "Maniacs", value = "Maniacs"},
        {text = "Unarmoured", value = "Unarmoured"},
        {text = "Unyielding", value = "Unyielding"},
        {text = "Infested", value = "Infested"},
        {text = "Specialists", value = "Specialists"},
        {text = "Elites", value = "Elites"},
        {text = "Poxwalkers", value = "Poxwalkers"},
        {text = "Weak Spot Damage", value = "Weak Spot Damage"},
	    }
    },
  }
}

return mod_data
