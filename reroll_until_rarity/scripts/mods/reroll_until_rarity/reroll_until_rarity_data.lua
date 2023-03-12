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
      setting_id    = "rur_enable_selected_perk",
      type          = "checkbox",
      default_value = false,
    },
    {
      setting_id      = "rur_max_attempts",
      type            = "numeric",
      default_value   = 10,
      range           = {1, 1000},
    },
    {
      setting_id    = "rur_hush_hadron",
      type          = "checkbox",
      default_value = false,
    },
    {
      setting_id      = "rur_cancel_keybind",
      type            = "keybind",
      keybind_trigger = "pressed",
      keybind_type    = "function_call",
      default_value   = {},
      function_name   = "cancel_operation"
    },
  }
}

local select_perk_dropdown_widget = {
  setting_id    = "rur_selected_perk",
  type          = "dropdown",
  default_value = "ANY",
  options = {
    {text = "rur_any_perk", value = "ANY"}
  }
}

-- Move descriptions to a sorted array for the dropdown widget
mod.all_perk_names = {}
for perk_name, _ in pairs(mod.perk_descriptions) do
  table.insert(mod.all_perk_names, perk_name)
end
table.sort(mod.all_perk_names, function(a, b) return a:upper() < b:upper() end)

for _, perk_name in ipairs(mod.all_perk_names) do
  table.insert(select_perk_dropdown_widget.options,
              #select_perk_dropdown_widget.options + 1,
              {text = perk_name, value = mod.perk_descriptions[perk_name]})
end
table.insert(mod_data.options.widgets, 3, select_perk_dropdown_widget)

return mod_data
