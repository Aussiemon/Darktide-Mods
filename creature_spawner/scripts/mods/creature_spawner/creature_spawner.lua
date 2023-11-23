local mod = get_mod("creature_spawner")

-- ##########################################################
-- ################## Variables #############################

local Actor = Actor
local HEALTH_ALIVE = HEALTH_ALIVE
local Managers = Managers
local PhysicsWorld = PhysicsWorld
local Quaternion = Quaternion
local ScriptUnit = ScriptUnit
local Unit = Unit
local Vector3 = Vector3
local World = World
local Wwise = Wwise

local math = math
local pairs = pairs
local string = string
local table = table
local type = type

local rapid_cooldown_enabled = false
local default_player_abilities = mod:persistent_table("default_player_abilities", {})
local player_abilities

local Breeds = require("scripts/settings/breed/breeds")
local MasterItems = require("scripts/backend/master_items")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")

local shooting_range_steps_path = "scripts/extension_systems/training_grounds/shooting_range_steps"
local shooting_range_scenarios_path = "scripts/extension_systems/training_grounds/shooting_range_scenarios"

mod.settings = mod:persistent_table("settings")

mod.breed_name_index = mod.breed_name_index or 1

mod:command("save_unit", "save selected creature to a slot number <1-3>",
    function(...) mod.save_unit_slot(...) end)
mod:command("selected_units", "report selected and saved Creature Spawner creatures",
    function(...) mod.unit_slots_report(...) end)

-- ##########################################################
-- ################## Local Functions #######################

local initialize_settings_cache = function()
  mod.settings["cs_unit_list"]                               = mod:get("cs_unit_list")
  mod.settings["cs_selected_unit"]                           = mod:get("cs_selected_unit")
  mod.settings["cs_saved_unit_one"]                          = mod:get("cs_saved_unit_one")
  mod.settings["cs_saved_unit_two"]                          = mod:get("cs_saved_unit_two")
  mod.settings["cs_saved_unit_three"]                        = mod:get("cs_saved_unit_three")
  mod.settings["cs_unit_side"]                               = mod:get("cs_unit_side")
  mod.settings["cs_enable_training_grounds_invisibility"]    = mod:get("cs_enable_training_grounds_invisibility")
  mod.settings["cs_enable_training_grounds_sound_muffler"]   = mod:get("cs_enable_training_grounds_sound_muffler")
  mod.settings["cs_enable_training_grounds_invulnerability"] = mod:get("cs_enable_training_grounds_invulnerability")
  mod.settings["cs_enable_training_grounds_respawn"]         = mod:get("cs_enable_training_grounds_respawn")
end

local is_valid_game_mode = function()
  local game_mode_name = Managers.state and Managers.state.game_mode and Managers.state.game_mode:game_mode_name()
  return game_mode_name and game_mode_name == "shooting_range"
end

local is_server = function()
  return Managers.state and Managers.state.game_session and Managers.state.game_session:is_server()
end

local get_player = function()
  local player_manager = Managers.player
  local player = player_manager and player_manager:local_player(1)
  
  return player
end

local get_player_unit = function(player)
  player = player or get_player()
  local player_unit = player and player:unit_is_alive() and player.player_unit
  
  return player_unit
end

local position_at_cursor = function(local_player)
  local viewport_name = local_player.viewport_name

  local camera_position = Managers.state.camera:camera_position(viewport_name)
  local camera_rotation = Managers.state.camera:camera_rotation(viewport_name)
  local camera_direction = Quaternion.forward(camera_rotation)

  local range = 500

  local world = Managers.world:world("level_world")
  local physics_world = World.get_data(world, "physics_world")

  local new_position
  local result = PhysicsWorld.immediate_raycast(physics_world,
                          camera_position,
                          camera_direction, range,
                          "all", "types",
                          "both", "collision_filter",
                          "filter_player_character_shooting_raycast_statics"
                          )

  if result then
    local num_hits = #result

    for i = 1, num_hits, 1 do
      local hit = result[i]
      local hit_actor = hit[4]
      local hit_unit = Actor.unit(hit_actor)
      local player_unit = get_player_unit()
      local ray_hit_self = player_unit and
                   (hit_unit == player_unit)

      if not ray_hit_self then
        new_position = hit[1]
        break
      end
    end
  end

  return new_position
end

-- Build lists of units
local build_unit_lists = function()
  
  -- Visit all breed entries
  for breed_name, _ in pairs(Breeds) do
    repeat
      if mod.breed_blacklist[breed_name] then
        break
      end
    
      -- Check for breed categories
      local categories = mod.unit_categories[breed_name]
      if categories then
        
        -- Add unit to category breed lists
        local num_individual_categories = #categories
        for i = 1, num_individual_categories do
          table.insert(mod[categories[i] .. "_units"], breed_name)
        end
        table.insert(mod["all_units"], breed_name)
      else
        mod:info("Unrecognized breed name " .. breed_name)
        table.insert(mod["all_units"], breed_name)
      end
    until true
  end
  
  -- Sort breed categories
  local num_categories = #mod.unit_category_names
  for i = 1, num_categories do
    table.sort(mod[mod.unit_category_names[i] .. "_units"], function(breed1, breed2) return breed1 < breed2 end)
  end
end

local get_selected_breed = function()
  return (mod[mod.settings["cs_unit_list"]])[mod.breed_name_index] or "chaos_poxwalker"
end

-- Take an ellipsis of arguments and transform them into a string
local process_argument_string = function(...)
  local args = {...}
  if args and #args > 0 then

    local this_argument = ""
     
    -- Process arguments into a single string
    for _, value in pairs(args) do
    
      if type(value) == "string" then
        if this_argument ~= "" then
          this_argument = this_argument .. " " .. value
        else
          this_argument = value
        end
        
      elseif type(value) == "table" then
        for _, value_value in pairs(value) do
          if type(value_value) == "string" then
            if this_argument ~= "" then
              this_argument = this_argument .. " " .. value_value
            else
              this_argument = value_value
            end
          end
        end
      end
    end
    
    return this_argument
  end
  
  return "nil"
end

-- ##########################################################
-- ################## Grim's EmptyShootingRange #############

local function unit_has_buff(unit, name)
  local buff_extension = ScriptUnit.extension(unit, "buff_system")
  if buff_extension then
    local buffs = buff_extension:buffs()

    for i = 1, #buffs do
      local template_name = buffs[i]:template_name()

      if template_name == name then
        return true
      end
    end
  end

  return false
end

local function add_unique_buff(unit, buff_name, scenario_data, t)
  scenario_data.unique_buffs = scenario_data.unique_buffs or {}
  local buff_extension = ScriptUnit.extension(unit, "buff_system")
  local _, buff_id, component_index = buff_extension:add_externally_controlled_buff(buff_name, t)
  local buff_data = {
    buff_id = buff_id,
    component_index = component_index
  }
  scenario_data.unique_buffs[buff_name] = buff_data
end

local function remove_unique_buff(unit, buff_name, scenario_data)
  if scenario_data.unique_buffs then
    local buff_data = scenario_data.unique_buffs[buff_name]
    local buff_extension = ScriptUnit.extension(unit, "buff_system")

    buff_extension:remove_externally_controlled_buff(buff_data.buff_id, buff_data.component_index)

    scenario_data.unique_buffs[buff_name] = nil
  end
end

local function enemies_loop_start_func(scenario_system, player_, scenario_data_, step_data)
  local enemy_spawners = scenario_system:get_spawn_group("shooting_range_enemies")
  local spawned_units = {}
  local fake_unit = 1

  for _, directional_unit_extension in pairs(enemy_spawners) do
    local identifier = directional_unit_extension:identifier()
    local breed_name = string.sub(identifier, 1, string.find(identifier, ":") - 1)

    spawned_units[fake_unit] = {
      breed_name = breed_name,
      spawner = directional_unit_extension
    }
    fake_unit = fake_unit + 1
  end

  step_data.units = spawned_units
end

local function enemies_loop_condition_func(scenario_system, player, scenario_data, step_data, t)
  if mod.settings["cs_enable_training_grounds_invisibility"] then
    if not unit_has_buff(player.player_unit, "tg_player_unperceivable") then
      add_unique_buff(player.player_unit, "tg_player_unperceivable", scenario_data, t)
    end
  else
    if unit_has_buff(player.player_unit, "tg_player_unperceivable") then
      remove_unique_buff(player.player_unit, "tg_player_unperceivable", scenario_data)
    end
  end
  
  if not mod.settings["cs_enable_training_grounds_sound_muffler"] then
    Wwise.set_state("music_zone", "on")
  else
    Wwise.set_state("music_zone", "shooting_range")
  end
  
  local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")
  if health_extension then
    if not mod.settings["cs_enable_training_grounds_invulnerability"] then
      health_extension:set_invulnerable(false)
    else
      health_extension:set_invulnerable(true)
    end
  end
  
  if mod.settings["cs_enable_training_grounds_respawn"] then
    local spawned_units = step_data.units

    for unit, spawner_data in pairs(spawned_units) do
      if not HEALTH_ALIVE[unit] then
        if not spawner_data.dissolve_t then
          spawner_data.dissolve_t = t + 2 + math.random_range(0, 1)
        elseif spawner_data.dissolve_t < t then
          scenario_system:dissolve_unit(unit, t)

          spawned_units[unit] = nil
          spawner_data.dissolve_t = nil
          local spawner = spawner_data.spawner
          local spawner_unit = spawner:unit()
          local position = Unit.local_position(spawner_unit, 1)
          local rotation = Unit.local_rotation(spawner_unit, 1)
          local breed_name = spawner_data.breed_name
          local new_unit = scenario_system:spawn_breed_ramping(breed_name, position, rotation, t, 2, 2, nil, "aggroed")

          Managers.event:trigger("add_world_marker_unit", "damage_indicator", new_unit)

          spawned_units[new_unit] = spawner_data
        end
      end
    end
  end
end

-- ##########################################################
-- #################### Mod Functions #######################

-- Copy table recursively: http://lua-users.org/wiki/CopyTable
mod.deepcopy = function(self, orig, copies)
  copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[mod:deepcopy(orig_key, copies)] = mod:deepcopy(orig_value, copies)
      end
      setmetatable(copy, mod:deepcopy(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

mod.spawn_breed_at_cursor = function(self, breed_name)
  if Managers.ui:chat_using_input() then
    return
  end
  if not is_server() then
    return
  end
  
  local minion_spawner = Managers.state and Managers.state.minion_spawn
  if not minion_spawner then
    mod:error("No minion spawner found.")
    return
  end

  local local_player = get_player()
  if not local_player then
    mod:error("Local player not found.")
    return
  end
  
  -- Get position and rotation from the local player
  local final_rotation
  local final_position = position_at_cursor(local_player)
  
  local local_player_unit = get_player_unit(local_player)
  if Unit.alive(local_player_unit) then
    final_rotation = Quaternion.multiply(Unit.local_rotation(local_player_unit, 1),
                      Quaternion(Vector3(0, 0, 1), math.pi))
  else
    final_rotation = Quaternion(0, 0, 0, 0)
  end
  
  -- Load this unit if the breed is available
  if Breeds[breed_name] then
    local side_id = 2 --mod.settings["cs_unit_side"]
    local unit = minion_spawner:spawn_minion(breed_name, final_position, final_rotation, side_id)
    
    if unit then
      mod:echo("Created " .. tostring(breed_name) .. ".")
    else
      mod:error(tostring(breed_name) .. " is not available.")
    end
  else
    mod:error("Breed " .. tostring(breed_name) .. " not recognized.")
  end
end

mod.spawn_selected_unit = function(self)
  mod:spawn_breed_at_cursor(mod.settings["cs_selected_unit"])
end

mod.spawn_saved_unit_one = function(self)
  mod:spawn_breed_at_cursor(mod.settings["cs_saved_unit_one"])
end

mod.spawn_saved_unit_two = function(self)
  mod:spawn_breed_at_cursor(mod.settings["cs_saved_unit_two"])
end

mod.spawn_saved_unit_three = function(self)
  mod:spawn_breed_at_cursor(mod.settings["cs_saved_unit_three"])
end

mod.next_breed = function(self)
  if Managers.ui:chat_using_input() then
    return
  end
  if not is_server() then
    return
  end

  -- Increment
  local start_index = mod.breed_name_index
  local selected_breed
  
  repeat
    -- Switch to the next unit
    mod.breed_name_index = mod.breed_name_index + 1
    if mod.breed_name_index > #(mod[mod.settings["cs_unit_list"]]) then
      mod.breed_name_index = 1
    end
    
    selected_breed = get_selected_breed()
    
    -- Switch to this unit if the package and breed are available
    local breed = Breeds[selected_breed]
    if breed then
      break
    end
  until mod.breed_name_index == start_index
  
  if mod.breed_name_index == start_index then
    mod:echo("No units from the selected list are available right now.")
  else
    mod:set("cs_selected_unit", selected_breed, true)
  end
end

mod.previous_breed = function(self)
  if Managers.ui:chat_using_input() then
    return
  end
  if not is_server() then
    return
  end

  -- Decrement
  local start_index = mod.breed_name_index
  local selected_breed
  
  repeat
    -- Switch to the next unit
    mod.breed_name_index = mod.breed_name_index - 1
    if mod.breed_name_index < 1 then
      mod.breed_name_index = #(mod[mod.settings["cs_unit_list"]])
    end
    
    selected_breed = get_selected_breed()
    
    -- Switch to this unit if the package and breed are available
    local breed = Breeds[selected_breed]
    if breed then
      break
    end
  until mod.breed_name_index == start_index
  
  if mod.breed_name_index == start_index then
    mod:echo("No units from the selected list are available right now.")
  else
    mod:set("cs_selected_unit", selected_breed, true)
  end
end

mod.despawn_units = function(self)
  if Managers.ui:chat_using_input() then
    return
  end
  if is_server() and is_valid_game_mode() and Managers.state.minion_spawn then
    Managers.state.minion_spawn:delete_units()
    mod:echo("Despawning all units.")
  end
end

-- Save the currently-selected unit to the given save slot
mod.save_unit_slot = function(...)
  
  local selected_breed = mod.settings["cs_selected_unit"]
  local slot = process_argument_string(...)
  
  if slot == "1" or slot == "one" then
    mod:set("cs_saved_unit_one", selected_breed, false)
    mod.settings["cs_saved_unit_one"] = selected_breed
    mod:echo("Saved " .. tostring(selected_breed) .. " to slot one.")
    
  elseif slot == "2" or slot == "two" then
    mod:set("cs_saved_unit_two", selected_breed, false)
    mod.settings["cs_saved_unit_two"] = selected_breed
    mod:echo("Saved " .. tostring(selected_breed) .. " to slot two.")
    
  elseif slot == "3" or slot == "three" then
    mod:set("cs_saved_unit_three", selected_breed, false)
    mod.settings["cs_saved_unit_three"] = selected_breed
    mod:echo("Saved " .. tostring(selected_breed) .. " to slot three.")
    
  else
    mod:error("Unrecognized save slot. Please use numbers 1-3.")
  end
end

-- Report selected and saved Creature Spawner creatures
mod.unit_slots_report = function(self)
  
  local selected_breed = mod.settings["cs_selected_unit"]
  
  mod:echo("Selected unit: "         .. selected_breed or "None")
  mod:echo("Saved unit slot one: "   .. mod.settings["cs_saved_unit_one"] or "None")
  mod:echo("Saved unit slot two: "   .. mod.settings["cs_saved_unit_two"] or "None")
  mod:echo("Saved unit slot three: " .. mod.settings["cs_saved_unit_three"] or "None")
end

-- ##########################################################
-- ################## Grim's Utilities ######################

mod.heal_player = function(self)
  if Managers.ui:chat_using_input() then
    return
  end
  local local_player_unit = get_player_unit()
  if local_player_unit and is_valid_game_mode() then
    local health_extension = ScriptUnit.has_extension(local_player_unit, "health_system")
    health_extension:add_heal(550, "blessing")
    health_extension:add_heal(550, "healing_station")
  end
end

mod.add_toughness = function(self)
  if Managers.ui:chat_using_input() then
    return
  end
  local local_player_unit = get_player_unit()
  if local_player_unit and is_valid_game_mode() then
    local toughness_extension = ScriptUnit.has_extension(local_player_unit, "toughness_system")
    if toughness_extension then
      toughness_extension:recover_percentage_toughness(100, true, "melee_kill")
    end
  end
end

mod.assist_player = function(self)
  if Managers.ui:chat_using_input() then
    return
  end
  local local_player_unit = get_player_unit()
  if local_player_unit and is_valid_game_mode() then
    local unit_data_extension = ScriptUnit.has_extension(local_player_unit, "unit_data_system")
    local character_state_component = unit_data_extension:read_component("character_state")
    local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
    local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)
    local is_netted = PlayerUnitStatus.is_netted(disabled_character_state_component)

    if is_knocked_down or is_netted then
      local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
      assisted_state_input_component.force_assist = true
    end
  end
end

mod.toggle_rapid_cooldown = function ()
  for _, ability in pairs(mod.ability_names) do
    if rapid_cooldown_enabled then
      if default_player_abilities[ability].cooldown then
        player_abilities[ability].cooldown = default_player_abilities[ability].cooldown
      end
      rapid_cooldown_enabled = false
    else
      if default_player_abilities[ability].cooldown then
        player_abilities[ability].cooldown = 1
      end
      rapid_cooldown_enabled = true
    end
  end

  mod:echo("Rapid Ability Cooldown: " .. (rapid_cooldown_enabled and "on" or "off"))
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook_require(shooting_range_steps_path, function(instance)
  instance.enemies_loop.start_func = enemies_loop_start_func
  instance.enemies_loop.condition_func = enemies_loop_condition_func
end)

mod:hook_require(shooting_range_scenarios_path, function(instance)
  if instance and instance.init and instance.init.steps and #instance.init.steps == 7 then
    table.remove(instance.init.steps, 3)
  end
end)

mod:hook_origin("MinionSuppressionExtension", "_get_threshold_and_max_value", function (self)
  local threshold = self._suppress_threshold or 9999
  local combat_range = self._behavior_component.combat_range

  if type(threshold) == "table" then
    threshold = threshold[combat_range] or 9999

    if type(threshold) == "table" then
      threshold = Managers.state.difficulty:get_table_entry_by_challenge(threshold) or 9999
    end
  end

  local max_value = self._max_suppress_value or 9999

  if type(max_value) == "table" then
    max_value = max_value[combat_range] or 9999

    if type(max_value) == "table" then
      max_value = Managers.state.difficulty:get_table_entry_by_challenge(max_value) or 9999
    end
  end

  return threshold, max_value
end)

mod:hook("MinionVisualLoadoutExtension", "init", function (func, self, extension_init_context,
                                                              unit, extension_init_data, ...)
  local cleaned_extension_init_data = mod:deepcopy(extension_init_data)
  local inventory = cleaned_extension_init_data.inventory
  local inventory_slots = inventory.slots
  local item_definitions = MasterItems.get_cached()

  local cleaned_inventory_slots = {}
  for slot_name, item_slot_data in pairs(inventory_slots) do
    -- For non material override slots
    if not item_slot_data.is_material_override_slot then
      local items = item_slot_data.items
      local cleaned_items = {}

      -- If the item exists in cached master items, add it to the new list
      for item_index = 1, #items do
        local item_name = items[item_index]
        if item_definitions[item_name] then
          table.insert(cleaned_items, item_name)
        else
          mod:error(item_name .. " doesn't exist.")
        end
      end

      -- If the new list has items, replace the old list
      if #cleaned_items > 0 then
        item_slot_data.items = cleaned_items

      -- If all items were removed, delete the rest of the item
      elseif #items ~= 0 then
        item_slot_data = nil
      end
    end

    -- If the item wasn't deleted, add it to the new slot data list
    if item_slot_data then
      cleaned_inventory_slots[slot_name] = item_slot_data
    end
  end

  -- Replace the slots with cleaned slots
  cleaned_extension_init_data.inventory.slots = cleaned_inventory_slots

  return func(self, extension_init_context, unit, cleaned_extension_init_data, ...)
end)

mod:hook_require("scripts/settings/ability/player_abilities/player_abilities", function(_player_abilities)
	default_player_abilities = table.clone(_player_abilities)
	table.set_readonly(default_player_abilities)
	player_abilities = _player_abilities
end)

-- ##########################################################
-- ################### Callbacks ############################

-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
  if not mod.settings["cs_selected_unit"] then
    local breed_name = get_selected_breed()
    mod:set("cs_selected_unit", breed_name, false)
    mod.settings["cs_selected_unit"] = breed_name
  end
end

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_name)
  mod.settings[setting_name] = mod:get(setting_name)

  if setting_name == "cs_unit_list" then
    
    mod.breed_name_index = 1
    local breed_name = get_selected_breed()
    mod:set("cs_selected_unit", breed_name, false)
    mod.settings["cs_selected_unit"] = breed_name

    mod:echo(">> " .. tostring(breed_name) .. ".")
    
  elseif setting_name == "cs_selected_unit" then
    mod:echo(">> " .. tostring(mod.settings["cs_selected_unit"]) .. ".")
  end
end

-- ##########################################################
-- ################### Script ###############################

build_unit_lists()
initialize_settings_cache()

-- ##########################################################
