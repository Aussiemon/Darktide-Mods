local mod = get_mod("fashion_randomizer")

-- ##########################################################
-- ################## Variables #############################

mod.settings = mod:persistent_table("settings")

local Archetypes = require("scripts/settings/archetype/archetypes")
local MasterItems = require("scripts/backend/master_items")

local random_item_blacklist = {
  female_african_face_01_cine_dummy = true
}

mod:command(mod:localize("fr_equip_command"), mod:localize("fr_equip_command_description"),
    function(...) mod:equip_random_items(...) end)

-- ##########################################################
-- ################## Functions #############################

local function initialize_settings_cache()
  mod.settings["fr_respect_archetypes"] = mod:get("fr_respect_archetypes")

  for _, slot_type in ipairs(mod.player_slots) do
    local setting_name = mod.player_slots_setting_map[slot_type]
    mod.settings[setting_name] = mod:get(setting_name)
  end
end

local get_random_profile = function(item_definitions, respect_archetypes)
  local random_item_names = mod:generate_random_profile(item_definitions, respect_archetypes)
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

  local counter = 0
  local report_string = "Replacing profile items: "
  for slot_name, item_data in pairs(override_loadout) do
    new_profile.loadout[slot_name] = item_data
    new_profile.visual_loadout[slot_name] = item_data
    local item_name = item_data.name
    if item_name then
      loadout_item_ids[slot_name] = item_name .. slot_name
      loadout_item_data[slot_name] = {
        id = item_name
      }
      if counter == 0 then
        report_string = report_string .. tostring(slot_name) .. " : " .. tostring(item_name)
      else
        report_string = report_string .. ", " .. tostring(slot_name) .. " : " .. tostring(item_name)
      end
      counter = counter + 1
    end
  end
  mod:info(report_string)

  return new_profile
end

mod.get_player = function(self)
  local player_manager = Managers.player
  local player = player_manager and player_manager:local_player(1)
  
  return player
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

mod.generate_random_profile = function(self, item_definitions, respect_archetypes)
  local archetype_names = {
    veteran = true,
    zealot = true,
    psyker = true,
    ogryn = true
  }
  
  local random_item_names = {
    [Archetypes.veteran] = {},
    [Archetypes.zealot] = {},
    [Archetypes.psyker] = {},
    [Archetypes.ogryn] = {}
  }
  
  local gender = false
  local player = mod:get_player()
  if player then
    local player_profile = player:profile()
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

mod.equip_items = function(self, custom_profile)
  local player = mod:get_player()
  if player then
    local player_profile = player:profile()
    local patched_profile = mod:replace_profile(player_profile, custom_profile)
    local peer_id = player:peer_id()
    local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

    if profile_synchronizer_host then
      profile_synchronizer_host:override_singleplay_profile(peer_id, 1, patched_profile)
    end
  end
end

mod.equip_random_items = function(self)
  local item_definitions = MasterItems.get_cached()
  mod:equip_items(get_random_profile(item_definitions, mod.settings["fr_respect_archetypes"]))
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook_safe(CLASS.GameModeTrainingGrounds, "init", function (self)
  local player = mod:get_player()
  if player and Managers.package_synchronization then
    self._package_synchronizer_host = Managers.package_synchronization:synchronizer_host()
    self._profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()
    self._peer_id = player:peer_id()
  end
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
