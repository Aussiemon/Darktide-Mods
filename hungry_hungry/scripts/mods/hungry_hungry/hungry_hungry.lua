local mod = get_mod("hungry_hungry")

-- ##########################################################
-- ################## Variables #############################

local Breeds = require("scripts/settings/breed/breeds")

local bt_minion_conditions_path = "scripts/extension_systems/behavior/utilities/conditions/bt_minion_conditions"

local breed_blacklist = {
  chaos_beast_of_nurgle = false
}

local all_consumable_breeds = {}
for breed_name, _ in pairs(Breeds) do
  if not breed_blacklist[breed_name] then
    all_consumable_breeds[breed_name] = true
  end
end

mod.persistent_data = mod:persistent_table("persistent_data")

mod.cached_no_player_conditions = mod:get("hh_no_player_conditions") or false
mod.cached_no_player_cooldown = mod:get("hh_no_player_cooldown") or true
mod.cached_no_minion_conditions = mod:get("hh_no_minion_conditions") or true
mod.cached_no_minion_cooldown = mod:get("hh_no_minion_cooldown") or true
mod.cached_eat_everything = mod:get("hh_eat_everything") or true

-- ##########################################################
-- ################## Functions #############################

local function set_blackboard_properties(blackboard)
  if blackboard and blackboard.behavior then
    if mod.cached_no_player_conditions then
      blackboard.behavior.wants_to_eat = true
    end

    -- Backup normal cooldown
    mod.persistent_data.player_consume_cooldown = mod.persistent_data.player_consume_cooldown or
                                                      blackboard.behavior.consume_cooldown

    if mod.cached_no_player_cooldown then
      blackboard.behavior.consume_cooldown = 0
    else
      blackboard.behavior.consume_cooldown = mod.persistent_data.player_consume_cooldown
    end

    -- Backup normal minion consume cooldown
    mod.persistent_data.minion_consume_cooldown = mod.persistent_data.minion_consume_cooldown or
                                                      blackboard.behavior.consume_minion_cooldown

    if mod.cached_no_minion_cooldown then
      blackboard.behavior.consume_minion_cooldown = 0
    else
      blackboard.behavior.consume_minion_cooldown = mod.persistent_data.minion_consume_cooldown
    end
  end
end

-- Copied from bt_minion_conditions
local function has_target_unit(unit, blackboard, scratchpad, condition_args, action_data, is_running)
  local perception_component = blackboard.perception

  if not is_running and perception_component.lock_target then
    return false
  end

  local target_unit = perception_component.target_unit

  return HEALTH_ALIVE[target_unit]
end

-- Copied from bt_minion_conditions
local function is_aggroed(unit, blackboard, scratchpad, condition_args, action_data, is_running)
  local has_target_unit_result = has_target_unit(unit, blackboard, scratchpad, condition_args, action_data, is_running)

  if not has_target_unit_result then
    return false
  end

  local perception_component = blackboard.perception
  return perception_component.aggro_state == "aggroed"
end

local function new_beast_of_nurgle_should_eat(unit, blackboard, scratchpad,
                                                            condition_args, action_data, is_running)

  local is_aggroed_result = is_aggroed(unit, blackboard, scratchpad, condition_args, action_data, is_running)
  if not is_aggroed_result then
    return false
  end

  if is_running then
    return true
  end

  local perception_component = blackboard.perception
  local target_is_close = perception_component.target_distance < 5

  if not target_is_close then
    return false
  end

  return true
end

local function deepcopy(orig, copies)
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
        copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
      end
      setmetatable(copy, deepcopy(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook_require(bt_minion_conditions_path, function(instance)
  instance.beast_of_nurgle_should_eat = new_beast_of_nurgle_should_eat
end)

mod:hook_safe(CLASS.BtBeastOfNurgleConsumeAction, "init_values", function (self, blackboard)
  set_blackboard_properties(blackboard)
end)

mod:hook(CLASS.BtChaosBeastOfNurgleSelectorNode, "evaluate", function (func, self, unit, blackboard, scratchpad, ...)
  set_blackboard_properties(blackboard)
  set_blackboard_properties(scratchpad)

  -- Adjust barriers for consume minion action
  if self._children and self._children[12] then
    mod.persistent_data.health_percent_threshold = mod.persistent_data.health_percent_threshold or
                                                    self._children[12].tree_node.action_data.health_percent_threshold
    mod.persistent_data.num_nearby_units_threshold = mod.persistent_data.num_nearby_units_threshold or
                                                    self._children[12].tree_node.action_data.num_nearby_units_threshold

    if mod.cached_no_minion_conditions then
      self._children[12].tree_node.action_data.health_percent_threshold = 9999
      self._children[12].tree_node.action_data.num_nearby_units_threshold = 1

    else
      self._children[12].tree_node.action_data.health_percent_threshold =
                                                  mod.persistent_data.health_percent_threshold
      self._children[12].tree_node.action_data.num_nearby_units_threshold =
                                                  mod.persistent_data.num_nearby_units_threshold
    end
  end

  return func(self, unit, blackboard, scratchpad, ...)
end)

mod:hook(CLASS.BtBeastOfNurgleConsumeMinionAction, "_get_target", function (func, self, unit, scratchpad, ...)
  set_blackboard_properties(scratchpad)

  -- Handle whether all breeds should be consumed
  if scratchpad and scratchpad.broadphase_config then
    mod.persistent_data.valid_breeds = mod.persistent_data.valid_breeds or
                                      deepcopy(scratchpad.broadphase_config.valid_breeds)
    
    if mod.cached_eat_everything then
      scratchpad.broadphase_config.valid_breeds = all_consumable_breeds
    else
      scratchpad.broadphase_config.valid_breeds = mod.persistent_data.valid_breeds
    end
  end

  return func(self, unit, scratchpad, ...)
end)

-- ##########################################################
-- ################## Callbacks #############################

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_name)
  if setting_name == "hh_no_player_conditions" then
    mod.cached_no_player_conditions = mod:get("hh_no_player_conditions")

  elseif setting_name == "hh_no_player_cooldown" then
    mod.cached_no_player_cooldown = mod:get("hh_no_player_cooldown")

  elseif setting_name == "hh_no_minion_conditions" then
    mod.cached_no_minion_conditions = mod:get("hh_no_minion_conditions")

  elseif setting_name == "hh_no_minion_cooldown" then
    mod.cached_no_minion_cooldown = mod:get("hh_no_minion_cooldown")

  elseif setting_name == "hh_eat_everything" then
    mod.cached_eat_everything = mod:get("hh_eat_everything")
  end
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
