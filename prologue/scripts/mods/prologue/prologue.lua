local mod = get_mod("prologue")

-- ##########################################################
-- ################## Variables #############################

local Missions = require("scripts/settings/mission/mission_templates")
local TrainingGroundsSoundEvents = require("scripts/settings/training_grounds/training_grounds_sound_events")

local Managers = Managers

local pairs = pairs
local type = type

-- ##########################################################
-- ################## Functions #############################

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
  
  return nil
end

-- Start the prologue mission with parameters
mod.start_prologue = function(...)
  if not (Managers.ui and Managers.multiplayer_session and Managers.mechanism) then return end

  local mechanism_context = {
    mission_name = "prologue",
    singleplay_type = "onboarding"
  }
  
  Managers.ui:play_2d_sound(TrainingGroundsSoundEvents.tg_hub_button)

  mechanism_context.challenge_level = tonumber(process_argument_string(...)) or 1
  mod:echo("Starting prologue...")
  
  local mission_name = mechanism_context.mission_name
  local mission_settings = Missions[mission_name]
  local mechanism_name = mission_settings.mechanism_name

  Managers.multiplayer_session:reset("Hosting prologue singleplayer mission")
  Managers.multiplayer_session:boot_singleplayer_session()

  Managers.mechanism:change_mechanism(mechanism_name, mechanism_context)
  Managers.mechanism:trigger_event("all_players_ready")
end

-- ##########################################################
-- #################### Hooks ###############################

-- ##########################################################
-- ################# Callbacks ##############################

-- ##########################################################
-- ################### Script ###############################

mod:command("prologue", "immediately starts the game prologue with the active character",
    function(...) mod.start_prologue(...) end)

-- ##########################################################
