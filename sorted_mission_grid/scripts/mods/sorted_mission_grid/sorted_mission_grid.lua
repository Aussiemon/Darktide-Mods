local mod = get_mod("sorted_mission_grid")

-- ##########################################################
-- ################## Variables #############################

mod.settings = mod:persistent_table("settings")

-- ##########################################################
-- ################## Functions #############################

local function initialize_settings_cache()
  mod.settings["smg_auto_refresh"] = mod:get("smg_auto_refresh")
  mod.settings["smg_sort_order"] = mod:get("smg_sort_order")
end

local function mission_sort_asc_func(k1, k2)
  -- Sort by challenge
  if k1.challenge < k2.challenge then
    return true
  elseif k1.challenge == k2.challenge then
    -- Sort by resistance
    if k1.resistance < k2.resistance then
      return true
    elseif k1.resistance == k2.resistance then
      -- Sort by circumstance or lack of
      local k1_circumstance_value = mod.circumstance_value[k1.circumstance] or 3
      local k2_circumstance_value = mod.circumstance_value[k2.circumstance] or 3

      if k1_circumstance_value < k2_circumstance_value then
        return true
      elseif k1_circumstance_value == k2_circumstance_value then
        -- Sort by side mission or lack of
        if (not k1.side_mission) and k2.side_mission then
          return true
        elseif k1.side_mission and (not k2.side_mission) then
          return false
        else
          -- Sort by guid
          return k1.id < k2.id
        end
      end
    end
  end

  return false
end

local function mission_sort_desc_func(k1, k2)
  -- Sort by challenge
  if k1.challenge > k2.challenge then
    return true
  elseif k1.challenge == k2.challenge then
    -- Sort by resistance
    if k1.resistance > k2.resistance then
      return true
    elseif k1.resistance == k2.resistance then
      -- Sort by circumstance or lack of
      local k1_circumstance_value = mod.circumstance_value[k1.circumstance] or 3
      local k2_circumstance_value = mod.circumstance_value[k2.circumstance] or 3

      if k1_circumstance_value > k2_circumstance_value then
        return true
      elseif k1_circumstance_value == k2_circumstance_value then
        -- Sort by side mission or lack of
        if (not k1.side_mission) and k2.side_mission then
          return false
        elseif k1.side_mission and (not k2.side_mission) then
          return true
        else
          -- Sort by guid
          return k1.id > k2.id
        end
      end
    end
  end

  return false
end

local function sort_missions(view)
  local is_modified = false

  local missions = view._backend_data.missions

  -- Wrapped in a pcall to prevent sort function crashes
  mod:pcall(function()
    if mod.settings["smg_sort_order"] == "asc" then
      table.sort(missions, mission_sort_asc_func)
    elseif mod.settings["smg_sort_order"] == "desc" then
      table.sort(missions, mission_sort_desc_func)
    elseif mod.settings["smg_sort_order"] == "unsorted" then
      -- Do nothing
    end
  end)

  for i = 1, #missions do
    if missions[i] and missions[i].displayIndex ~= i then
      missions[i].displayIndex = i
      is_modified = true
    end
  end

  return is_modified
end

local function clear_mission_board(view)
  local mission_widgets = view._mission_widgets
  for i = #mission_widgets, 1, -1 do
    local widget = mission_widgets[i]

    if not widget.content.exit_anim_id then
      widget.content.exit_anim_id = view:_start_animation(
        "mission_small_exit", widget, view, nil, 1, math.random_range(0, 0.5)
      )
    end
  end
  view._selected_mission = nil
end

mod.queue_reset_board = function(self)
  mod.settings.reset_board = true
end

-- ##########################################################
-- #################### Hooks ###############################

-- Replace vanilla positions with grid view
mod:hook_safe(CLASS.MissionBoardView, "init", function (self)
  mod.settings.reset_board = false
  self._free_widget_positions = table.merge({}, mod.custom_mission_positions)
end)

-- Handle keybind to reset the mission board
mod:hook_safe(CLASS.MissionBoardView, "update", function (self)
  if mod.settings.reset_board then
    mod.settings.reset_board = false
    sort_missions(self)
    clear_mission_board(self)
  end
end)

-- Sort missions and clear mission widgets if necessary
mod:hook(CLASS.MissionBoardView, "_join_mission_data", function (func, self, ...)
  local should_clear = sort_missions(self) and #self._mission_widgets > 0

  local result = func(self, ...)

  if should_clear and mod.settings["smg_auto_refresh"] then
    clear_mission_board(self)
  end

  return result
end)

-- Rebuild mission widgets if we've cleared the board
mod:hook_safe(CLASS.MissionBoardView, "_callback_mission_widget_exit_done", function (self)
  if #self._mission_widgets == 0 and self._backend_data and #self._backend_data.missions > 0 then
    mod.settings.reset_board = false
    self._free_widget_positions = table.merge({}, mod.custom_mission_positions)

    self:_join_mission_data()
  end
end)

-- ##########################################################
-- ################# Callbacks ##############################

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_id)
  mod.settings[setting_id] = mod:get(setting_id)
  mod.settings.reset_board = true
end

-- ##########################################################
-- ################### Script ###############################

initialize_settings_cache()

-- ##########################################################