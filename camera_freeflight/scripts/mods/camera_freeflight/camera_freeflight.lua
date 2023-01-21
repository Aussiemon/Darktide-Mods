local mod = get_mod("camera_freeflight")

-- ##########################################################
-- ################## Variables #############################

local FreeFlightManager = require("scripts/foundation/managers/free_flight/free_flight_manager")
local Views = require("scripts/ui/views/views")

local _freeflight_data = mod:persistent_table("freeflight_data")

-- ##########################################################
-- ################## Functions #############################

local toggle_look_input = function()
  return false -- Keyboard.pressed(Keyboard.button_index("["))
end

local teleport_player_to_camera = function()
  return false -- Keyboard.pressed(Keyboard.button_index("]"))
end

local patch_require_store = function()
  local free_flight_default_input_require_store = mod:get_require_store(
    "scripts/foundation/managers/free_flight/free_flight_default_input"
  ) or {}
  for _, instance in pairs(free_flight_default_input_require_store) do
    if not instance.toggle_look_input then
      instance.toggle_look_input = toggle_look_input
    end
    if not instance.teleport_player_to_camera then
      instance.teleport_player_to_camera = teleport_player_to_camera
    end
  end
end

mod.use_3p_hub_camera = function(self)
  if Managers.state and Managers.state.game_mode and Managers.state.game_mode.use_third_person_hub_camera then
    return Managers.state.game_mode:use_third_person_hub_camera()
  end
  
  return false
end

mod.is_in_free_flight = function(self)
  return Managers.free_flight and Managers.free_flight:is_in_free_flight()
end

mod.get_player = function(self)
  local player_manager = Managers.player
  local player = player_manager and Network and player_manager:local_player(1)
  
  return player
end

mod.get_player_unit = function(self)
  local player = mod:get_player()
  local player_unit = player and player:unit_is_alive() and player.player_unit
  
  return player_unit
end

mod.set_3p = function(self, enabled)
  local player_unit = mod:get_player_unit()
  if player_unit then
    local player_1p_extension = ScriptUnit.has_extension(player_unit, "first_person_system")
    if player_1p_extension then
      player_1p_extension._force_third_person_mode = enabled
    end
  end
end

mod.toggle_freeflight = function(self)
  _freeflight_data.enable_freeflight = not _freeflight_data.enable_freeflight
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook(CLASS.FreeFlightDefaultInput, "get", function (func, self, action_name, ...)
  if action_name == "global_toggle" then
    if mod:is_in_free_flight() then
      return not _freeflight_data.enable_freeflight
    else
      return _freeflight_data.enable_freeflight
    end
  end

  -- Prevent missing hotkeys
  if not self[action_name] then
    return false
  end
  
  return func(self, action_name, ...)
end)

mod:hook_safe(CLASS.StateGameplay, "on_enter", function (self)
  _freeflight_data.ready = true
end)

mod:hook_safe(CLASS.StateGameplay, "on_exit", function (self)
  _freeflight_data.ready = false
end)

mod:hook_safe(CLASS.StateGame, "update", function (self, dt)

  -- Update the freeflight manager
  if Managers.free_flight then
    local main_t = Managers.time:time("main")
    Managers.free_flight:update(dt, main_t)
    
    if _freeflight_data.ready and not mod:use_3p_hub_camera() then
      mod:set_3p(mod:is_in_free_flight())
    end
  end
end)

mod:hook_safe(CLASS.UIManager, "open_view", function (self, view_name)
  local view_settings = Views[view_name]
  if not view_settings or view_settings.disable_game_world == true then
    _freeflight_data.enable_freeflight = false
  end
end)

mod:hook_safe(CLASS.UIManager, "close_view", function (self, view_name)
  local view_settings = Views[view_name]
  if not view_settings or view_settings.disable_game_world == true then
    _freeflight_data.enable_freeflight = false
  end
end)

-- ##########################################################
-- ################### Callback #############################

-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
  _freeflight_data.enable_freeflight = false

  patch_require_store()
end

-- ##########################################################
-- ################### Script ###############################

Managers.free_flight = Managers.free_flight or FreeFlightManager:new()

Managers.free_flight.STD_MINIMUM_SPEED = 0.5
Managers.free_flight.STD_MAXIMUM_SPEED = 30

_freeflight_data.enable_freeflight = false

patch_require_store()

-- ##########################################################
