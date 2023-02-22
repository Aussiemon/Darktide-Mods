local mod = get_mod("camera_freeflight")

-- ##########################################################
-- ################## Variables #############################

local FreeFlightManager = require("scripts/foundation/managers/free_flight/free_flight_manager")
local PlayerMovement = require("scripts/utilities/player_movement")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local Views = require("scripts/ui/views/views")

local free_flight_default_input_path = "scripts/foundation/managers/free_flight/free_flight_default_input"

local _freeflight_data = mod:persistent_table("freeflight_data")

local Camera = Camera
local Managers = Managers
local Quaternion = Quaternion
local Network = Network
local ScriptUnit = ScriptUnit
local Vector3 = Vector3

mod.settings = mod:persistent_table("settings")

-- ##########################################################
-- ################## Functions #############################

local initialize_settings_cache = function()
  mod.settings["cf_teleport_player"] = mod:get("cf_teleport_player")
end

local pressed_toggle_look_input = function()
  return false -- Keyboard.pressed(Keyboard.button_index("["))
end

local pressed_teleport_player_to_camera = function()
  return false -- Keyboard.pressed(Keyboard.button_index("]"))
end

local is_server = function()
  return Managers.state and Managers.state.game_session and Managers.state.game_session:is_server()
end

local teleport_player_to_camera = function(cam, player)
  local pos = Camera.local_position(cam)
  local rot = Camera.local_rotation(cam)
  
  -- Flat-level position of player relative to camera
  local offset = { x = -0.8, y = 0.6, z = -1.2 }
  
  -- Modifier for z-axis depending on pitch of camera
  local pitch = math.abs(Quaternion.pitch(rot))
  local percent_change = pitch / math.pi
  offset.z = offset.z - ((2 * offset.z) * percent_change)
  
  -- Apply offset to get final player position
  local x = offset.x * Quaternion.right(rot)
  local y = offset.y * Quaternion.forward(rot)
  local z = Vector3(0, 0, offset.z)
  pos = pos + x + y + z
  
  PlayerMovement.teleport(player, pos, rot)
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

mod:hook_file(free_flight_default_input_path, function(instance)
  if not instance.toggle_look_input then
    instance.toggle_look_input = pressed_toggle_look_input
  end
  if not instance.teleport_player_to_camera then
    instance.teleport_player_to_camera = pressed_teleport_player_to_camera
  end
end)

mod:hook_safe(CLASS.FreeFlightManager, "_update_camera", function (self, input_, dt_, camera_data)
  if mod.settings["cf_teleport_player"] and is_server() then
    local world = Managers.world:world(camera_data.viewport_world_name)
    local viewport = world and ScriptWorld.global_free_flight_viewport(world)
    local cam = camera_data.frustum_freeze_camera or viewport and ScriptViewport.camera(viewport)
    
    -- Always change player position while flying
    local player = Managers.player:local_player(1)
    if cam and player then
      teleport_player_to_camera(cam, player)
    end
  end
end)

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
end

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_name)
  mod.settings[setting_name] = mod:get(setting_name)
end

-- ##########################################################
-- ################### Script ###############################

Managers.free_flight = Managers.free_flight or FreeFlightManager:new()

Managers.free_flight.STD_MINIMUM_SPEED = 0.5
Managers.free_flight.STD_MAXIMUM_SPEED = 30

_freeflight_data.enable_freeflight = false

initialize_settings_cache()

-- ##########################################################
