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
      default_value   = 300,
      range           = {1, 3000},
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
mod.all_perk_descriptions = {}
for localized_description, _ in pairs(mod.perk_ids_by_description) do
  table.insert(mod.all_perk_descriptions, localized_description)
end
table.sort(
  mod.all_perk_descriptions, function(a, b)
    return a:upper() < b:upper()
  end
)

local perk_ids = {}

for _, localized_description in ipairs(mod.all_perk_descriptions) do
  local perk_id = mod.perk_ids_by_description[localized_description]
  if not perk_ids[perk_id] then
    table.insert(
      select_perk_dropdown_widget.options,
      #select_perk_dropdown_widget.options + 1,
      {
        -- Display text will be localized, stored value will be localization_id
        text = perk_id,
        value = perk_id
      }
    )
    perk_ids[perk_id] = true
  else
    mod:warning(perk_id .. " already associated with " .. localized_description)
  end
end
table.insert(mod_data.options.widgets, 3, select_perk_dropdown_widget)

return mod_data
