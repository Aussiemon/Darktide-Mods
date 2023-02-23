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

--- Keep rerolling until configurations are met
mod:hook_origin(CLASS.CraftingRerollPerkView, "_perform_crafting", function (self)
  if self._craft_promise then
    return
  end

  self._crafting_recipe:play_craft_animation()

  local recipe = self._recipe

  if recipe then
    self:_play_sound(recipe.sound_event)
  end

  self._crafting_recipe:set_continue_button_force_disabled(true)

  local existing_perk_index = self._ingredients.existing_perk_index
  local craft_promise = self._parent:craft(recipe, self._ingredients)
  self._craft_promise = craft_promise

  craft_promise:next(function (results)
    attempt_counter = attempt_counter + 1

    self._craft_promise = nil
    local new_item = results.items[1]
    self._item = new_item
    self._ingredients.item = new_item

    -- ## Modded lines start ##
    local new_perk = new_item.perks[existing_perk_index]
    local new_perk_id = new_perk.id
    local perk_item = MasterItems.get_item(new_perk_id)

    local perk_display_name = ItemUtils.perk_description(perk_item, new_perk.rarity, new_perk.value)
    self._perk_display_name = perk_display_name
    
    local desired_rarity = mod:get("rur_desired_rarity")
    if new_perk.rarity >= desired_rarity then
      mod:notify(safe_format("Rarity " .. tostring(desired_rarity) .. " reached in " ..
                                                  tostring(attempt_counter) .. " attempts."))
      cancel_operation = false
      attempt_counter = 0
      self:cb_on_perk_selected(nil, nil)

    elseif cancel_operation or attempt_counter >= mod:get("rur_max_attempts") then
      mod:notify(safe_format("Last attempt #" .. tostring(attempt_counter) .. ": " .. tostring(perk_display_name)))
      cancel_operation = false
      attempt_counter = 0
      self:cb_on_perk_selected(nil, nil)

    else
      mod:notify(safe_format("#" .. tostring(attempt_counter) .. ": " .. tostring(perk_display_name)))
      self:_perform_crafting()
    end
    -- ## Modded lines end ##
    
    -- Removed self:cb_on_perk_selected(nil, nil) from this callback
    local optional_present_callback = callback(function ()
      local marked_widget = nil
      local recipe_widgets = self._crafting_recipe:widgets()
      local perk_widget_index_counter = 0

      for i = 1, #recipe_widgets do
        local recipe_widget = recipe_widgets[i]
        local content = recipe_widget.content

        if content.rank then
          perk_widget_index_counter = perk_widget_index_counter + 1

          if perk_widget_index_counter == existing_perk_index then
            marked_widget = recipe_widget
            break
          end
        end
      end
    end)

    -- New perk item logic moved above
    self:_present_crafting(optional_present_callback)
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
