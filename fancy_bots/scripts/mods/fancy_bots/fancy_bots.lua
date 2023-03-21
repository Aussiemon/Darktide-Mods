local mod = get_mod("fancy_bots")

-- ##########################################################
-- ################## Variables #############################

mod.settings = mod:persistent_table("settings")

local Archetypes = require("scripts/settings/archetype/archetypes")
local MasterItems = require("scripts/backend/master_items")
local ProfileUtils = require("scripts/utilities/profile_utils")

local random_item_blacklist = {
  female_african_face_01_cine_dummy = true
}


-- ##########################################################
-- ################## Functions #############################

local function initialize_settings_cache()
  mod.settings["fb_randomize"] = mod:get("fb_randomize")

  for _, slot_type in ipairs(mod.player_slots) do
    local setting_name = mod.player_slots_setting_map[slot_type]
    mod.settings[setting_name] = true --mod:get(setting_name)
  end
end

local get_random_profile = function(item_definitions, player_profile)
  local random_item_names = mod:generate_random_profile(item_definitions, player_profile)
  local custom_profiles = {
    [Archetypes.veteran] = {
      loadout = {}
    },
    [Archetypes.zealot] = {
      loadout = {}
    },
    [Archetypes.psyker] = {
      loadout = {}
    },
    [Archetypes.ogryn] = {
      loadout = {}
    }
  }

  for archetype, _ in pairs(custom_profiles) do
    for _, slot_type in ipairs(mod.player_slots) do
      if mod.settings[mod.player_slots_setting_map[slot_type]] then
        custom_profiles[archetype].loadout[slot_type] = item_definitions[random_item_names[archetype][slot_type]]
      end
    end
  end

  return custom_profiles
end

local function get_custom_profile(player_profile)
  local custom_profile
  local item_definitions = MasterItems.get_cached()

  if mod.settings["fb_randomize"] then
    custom_profile = get_random_profile(item_definitions, player_profile)
  else
    custom_profile = {
      [Archetypes.veteran] = {
        loadout = {
          slot_gear_lowerbody =
            item_definitions["content/items/characters/player/human/gear_lowerbody/d7_veteran_m_lowerbody"],
          slot_gear_upperbody =
            item_definitions["content/items/characters/player/human/gear_upperbody/d7_veteran_m_upperbody"],
          slot_gear_head =
            item_definitions["content/items/characters/player/human/gear_head/d7_veteran_m_headgear"],
        }
      },
      [Archetypes.zealot] = {
        loadout = {}
      },
      [Archetypes.psyker] = {
        loadout = {}
      },
      [Archetypes.ogryn] = {
        loadout = {}
      },
    }
  end

  return custom_profile
end

mod.replace_profile = function(self, profile, custom_profile)
  local override_profiles = custom_profile
  local archetype = profile.archetype
  local override_table = override_profiles[archetype]

  if not override_table then
    return profile
  end

  local new_profile = table.clone_instance(profile)
  local loadout_item_ids = new_profile.loadout_item_ids
  local loadout_item_data = new_profile.loadout_item_data
  local override_loadout = override_table.loadout

  for slot_name, item_data in pairs(override_loadout) do
    new_profile.loadout[slot_name] = item_data
    new_profile.visual_loadout[slot_name] = item_data
    local item_name = item_data.name
    if item_name then
      loadout_item_ids[slot_name] = item_name .. slot_name
      loadout_item_data[slot_name] = {
        id = item_name
      }
    end
  end

  return new_profile
end

mod.check_item_table = function(self, item_table, value, empty_means_true)
  if not item_table then
    return false
  elseif empty_means_true and #item_table == 0 then
    return true
  else
    for i = 1, #item_table do
      if item_table[i] == value then
        return true
      end
    end
  end
  return false
end

mod.generate_random_profile = function(self, item_definitions, player_profile)
  local respect_archetypes = true
  
  local archetype_names = {
    veteran = true,
    zealot = false,
    psyker = false,
    ogryn = false
  }
  
  local random_item_names = {
    [Archetypes.veteran] = {},
    [Archetypes.zealot] = {},
    [Archetypes.psyker] = {},
    [Archetypes.ogryn] = {}
  }
  
  local gender = false
  if player_profile then
    gender = player_profile.gender
  end
  
  local item_definitions_array = {}
  for item_name, item_data in pairs(item_definitions) do
    item_data.name = item_name
    item_definitions_array[#item_definitions_array + 1] = item_data
  end
  
  local num_items = #item_definitions_array
  for archetype, _ in pairs(archetype_names) do
    for _, slot_name in pairs(mod.player_slots) do
    
      local i = 0
      local item_name
      
      while(i < num_items) do
        repeat
          local item_number = math.random(num_items)
          local item = item_definitions_array[item_number]
          if item and item.archetypes and item.breeds and item.slots and not random_item_blacklist[item.name] then
            --mod:debug(item.name)
            local pass_archetype = mod:check_item_table(item.archetypes, archetype, true)
            if respect_archetypes and not pass_archetype then break end
            --mod:debug(item.name .. " archetype")
            
            local breed = archetype == "ogryn" and "ogryn" or "human"
            local pass_breeds = mod:check_item_table(item.breeds, breed, true)
            if not pass_breeds then break end
            --mod:debug(item.name .. " breed")
            
            local pass_slot = mod:check_item_table(item.slots, slot_name, false)
            if not pass_slot then break end
            --mod:debug(item.name .. " slot")
            
            local pass_gender = (not gender) or (not item.genders) or mod:check_item_table(item.genders, gender, true)
            if not pass_gender then break end
            --mod:debug(item.name .. " succeeded with " .. tostring(archetype))
            
            item_name = item.name
          end
        until true
        
        if item_name then
          break
        end
        
        i = i + 1
      end
      
      random_item_names[Archetypes[archetype]][slot_name] = item_name
    end
  end
  
  return random_item_names
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook(CLASS.BotSynchronizerClient, "rpc_add_bot_player", function (func, self, channel_id, local_player_id, ...)

  -- Unpack existing profile
  local peer_id = Network.peer_id(channel_id)
  local prof_sync_client = Managers.profile_synchronization:synchronizer_client()
  local profile_json = prof_sync_client:player_profile_json(peer_id, local_player_id)
  local profile = ProfileUtils.unpack_profile(profile_json)
  
  -- Get the new profile
  local custom_profile = get_custom_profile(profile)
  if custom_profile then
    local new_profile = mod:replace_profile(profile, custom_profile)
    
    -- Update the profile synchronizer client
    local new_profile_json = ProfileUtils.pack_profile(new_profile)
    local new_profile_chunks = {}
    ProfileUtils.split_for_network(new_profile_json, new_profile_chunks)
    
    local peer_profile_chunks = prof_sync_client._peer_profile_chunks
    local peer_profiles_json = prof_sync_client._peer_profiles_json

    peer_profile_chunks[peer_id] = peer_profile_chunks[peer_id] or {}
    peer_profile_chunks[peer_id][local_player_id] = new_profile_chunks
    peer_profiles_json[peer_id] = peer_profiles_json[peer_id] or {}
    peer_profiles_json[peer_id][local_player_id] = new_profile_json

    mod:dtf(new_profile, ("bot_new_profile_" .. tostring(local_player_id)), 10)
    mod:echo("Modified host-added bot")
  end

  return func(self, channel_id, local_player_id, ...)
end)

mod:hook(CLASS.PlayerManager, "create_players_from_sync_data", function (
            func, self, player_class, channel_id, peer_id,
            is_server, local_player_id_array, is_human_controlled_array,
            account_id_array, profile_chunks_array, ...
)
  for i = 1, #local_player_id_array do
    repeat
      -- Determine if the player is human-controlled
      local is_human_controlled = is_human_controlled_array[i]
      if not is_human_controlled then break end
      
      -- Get the player's profile
      local profile_chunks = profile_chunks_array[i]
      local profile_json = ProfileUtils.combine_network_chunks(profile_chunks)
      local profile = ProfileUtils.unpack_profile(profile_json)

      -- Check for bot indicator in profile
      if not profile.bot_gestalts then break end

      -- Create the new profile
      local custom_profile = get_custom_profile(profile)
      if not custom_profile then break end

      local new_profile = mod:replace_profile(profile, custom_profile)
      
      -- Get the new profile chunks
      local new_profile_json = ProfileUtils.pack_profile(new_profile)
      local new_profile_chunks = {}
      ProfileUtils.split_for_network(new_profile_json, new_profile_chunks)
      
      -- Update the bot profile
      profile_chunks_array[i] = new_profile_chunks

      mod:dtf(new_profile, ("bot_new_profile_" .. tostring(peer_id)), 10)
      mod:echo("Modified sync-added bot")
    until true
  end

  return func(
    self, player_class, channel_id, peer_id,
    is_server, local_player_id_array, is_human_controlled_array,
    account_id_array, profile_chunks_array, ...
  )
end)

mod:hook(CLASS.PlayerHuskVisualLoadoutExtension, "_equip_item_to_slot", function (func, self, slot_name, item, ...)
  return item and func(self, slot_name, item, ...)
end)

-- ##########################################################
-- ################# Callbacks ##############################

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_id)
  mod.settings[setting_id] = mod:get(setting_id)
end

-- ##########################################################
-- ################### Script ###############################

initialize_settings_cache()

-- ##########################################################
