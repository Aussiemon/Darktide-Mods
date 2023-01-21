local mod = get_mod("reroll_until_rarity")

-- ##########################################################
-- ################## Variables #############################

local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")

local attempt_counter = 0
local cancel_operation = false

-- ##########################################################
-- ################## Functions #############################

local safe_format = function(str)
  return string.gsub(str, "%%", "%%%%")
end

mod.cancel_operation = function(self)
  cancel_operation = true
end

-- ##########################################################
-- #################### Hooks ###############################

-- Reset counter and cancel flag whenever the view is opened
mod:hook_safe(CLASS.CraftingRerollPerkView, "on_enter", function (self)
  attempt_counter = 0
  cancel_operation = false
end)

-- Keep rerolling until configurations are met
mod:hook_origin(CLASS.CraftingRerollPerkView, "cb_on_main_button_pressed", function (self, widget, config)
  if self._craft_promise then
    return
  end

  widget.content.hotspot.disabled = true

  self._crafting_recipe:play_craft_animation()

  local craft_promise = self._parent:craft(self._recipe, self._ingredients)
  self._craft_promise = craft_promise

  craft_promise:next(function (new_item)
    attempt_counter = attempt_counter + 1
    self._craft_promise = nil
    
    local new_perk = new_item.perks[self._ingredients.existing_perk_index]
    local new_perk_id = new_perk.id
    
    local perk_item = MasterItems.get_item(new_perk_id)
    local perk_display_name = ItemUtils.perk_description(perk_item, new_perk.rarity, new_perk.value)
    
    local desired_rarity = mod:get("rur_desired_rarity")
    if new_perk.rarity >= desired_rarity then
      mod:notify(safe_format("Rarity " .. tostring(desired_rarity) .. " reached in " ..
                                                  tostring(attempt_counter) .. " attempts."))
      cancel_operation = false
      attempt_counter = 0
    elseif cancel_operation or attempt_counter >= mod:get("rur_max_attempts") then
      mod:notify(safe_format("Last attempt #" .. tostring(attempt_counter) .. ": " .. tostring(perk_display_name)))
      cancel_operation = false
      attempt_counter = 0
    else
      mod:notify(safe_format("#" .. tostring(attempt_counter) .. ": " .. tostring(perk_display_name)))
      self:cb_on_main_button_pressed(widget, config)
    end
    
    self._item = new_item
    self._ingredients.item = new_item
    self:_present_crafting()
    self._perk_display_name = perk_display_name
    
  end, function ()
    self._craft_promise = nil
  end)
end)

-- Get rid of the vanilla reroll notification
mod:hook(CLASS.CraftingView, "craft", function (func, self, recipe, ...)
  if recipe and recipe.name and recipe.name == "reroll_perk" then
    recipe.success_text = nil
  end
  
  return func(self, recipe, ...)
end)

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
