local mod = get_mod("bot_spawner")

-- https://vmf-docs.verminti.de

-- ##########################################################
-- ################## Variables #############################

local BotCharacterProfiles = require("scripts/settings/bot_character_profiles")
local BotSpawning = require("scripts/managers/bot/bot_spawning")
local MasterItems = require("scripts/backend/master_items")

local num_bot_profiles = 0
local bot_profile_names

local bot_blacklist = {
  ogryn_c_the_brawler = true
}

local profile_counter = 1
local last_bot_spawn_time = -1

-- ##########################################################
-- ################## Functions #############################

local setup_profiles = function()

  local item_definitions = MasterItems.get_cached()
  if not item_definitions then
    mod:error(mod:localize("error_profiles_not_ready"))
    return false
  end

  local profiles = BotCharacterProfiles(item_definitions)
  bot_profile_names = {}
  
  for profile_name, _ in pairs(profiles) do
    if profile_name and not bot_blacklist[profile_name] then
      num_bot_profiles = num_bot_profiles + 1
      bot_profile_names[num_bot_profiles] = profile_name
    end
  end
  table.sort(bot_profile_names)

  return true
end

mod.next_bot = function(self, silent)
  if Managers.ui:chat_using_input() then
    return
  end

  -- Check for initialization
  if not bot_profile_names then
    if not setup_profiles() then
      return
    end
  end

  -- Check for is_server status
  local is_server = Managers.state and Managers.state.game_session and Managers.state.game_session:is_server()
  if not is_server then
    return
  end

  -- Switch to the next bot
  profile_counter = profile_counter + 1

  -- Reset counter if next bot doesn't exist
  if not bot_profile_names[profile_counter] then
    profile_counter = 1
  end

  -- Announce the new name
  if not silent then
    mod:echo(mod:localize("next_bot_text") .. bot_profile_names[profile_counter])
  end
end

mod.spawn_bot = function(self)
  if Managers.ui:chat_using_input() then
    return
  end

  -- Check for initialization
  if not bot_profile_names then
    if not setup_profiles() then
      return
    end
  end

  -- Check for is_server status
  local is_server = Managers.state and Managers.state.game_session and Managers.state.game_session:is_server()
  if not is_server then
    return
  end
  
  -- Get the bot profile name
  local profile_name = bot_profile_names[profile_counter]
  if profile_name then

    -- Make sure we're not spawning bots too quickly
    local prev_bot_spawn_time = last_bot_spawn_time
    local curr_bot_spawn_time = Managers.time:time("main")

    if curr_bot_spawn_time - prev_bot_spawn_time >= 2 then
      last_bot_spawn_time = curr_bot_spawn_time

      mod:echo(mod:localize("spawning_bot_text") .. tostring(profile_name))
      BotSpawning.spawn_bot_character(profile_name)

      if mod:get("next_bot_on_spawn") then
        mod:next_bot(true)
      end
    else
      mod:warning(mod:localize("error_delay_spawn_text"))
    end
  else
    mod:error(mod:localize("error_profile_bot_text") .. tostring(profile_counter) .. ":" .. tostring(profile_name))
    profile_counter = 1
  end
end

mod.despawn_bot = function(self)
  if Managers.ui:chat_using_input() then
    return
  end

  local is_server = Managers.state and Managers.state.game_session and Managers.state.game_session:is_server()
  if is_server then
    --mod:echo(mod:localize("despawning_bot_text"))
    BotSpawning.despawn_best_bot()
  end
end

-- ##########################################################
-- #################### Hooks ###############################

-- ##########################################################
-- ################### Callback #############################

mod.on_game_state_changed = function(status, state)
  if status == "enter" and state == "StateIngame" then
    setup_profiles()
  end
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
