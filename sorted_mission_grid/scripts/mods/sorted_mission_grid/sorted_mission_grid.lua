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
  local t = Managers.time:time("main")

  -- Ensure flash missions are at the end of the sort order
  if k1.flags and k1.flags.flash and (not k2.flags or not k2.flags.flash) then
    return false
  elseif (not k1.flags or not k1.flags.flash) and k2.flags and k2.flags.flash then
    return true

  -- Ensure time-hidden missions are at the end of the sort order
  -- elseif t < k1.start_game_time and t >= k2.start_game_time then
  --   return false
  -- elseif t >= k1.start_game_time and t < k2.start_game_time then
  --   return true

  -- Sort by challenge
  elseif k1.challenge < k2.challenge then
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
  local t = Managers.time:time("main")

  -- Ensure flash missions are at the end of the sort order
  if k1.flags and k1.flags.flash and (not k2.flags or not k2.flags.flash) then
    return false
  elseif (not k1.flags or not k1.flags.flash) and k2.flags and k2.flags.flash then
    return true

  -- Ensure time-hidden missions are at the end of the sort order
  -- elseif t < k1.start_game_time and t >= k2.start_game_time then
  --   return false
  -- elseif t >= k1.start_game_time and t < k2.start_game_time then
  --   return true

  -- Sort by challenge
  elseif k1.challenge > k2.challenge then
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
  local missions = view._backend_data and view._backend_data.filtered_missions
  if not missions then return false end

  local is_modified = false

  -- Show missions that haven't quite started yet
  local t = Managers.time:time("main")
  for i = 1, #missions do
    if missions[i] and t < missions[i].start_game_time then
      missions[i].start_game_time = t - 1
    end
  end

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
  view:_set_selected_quickplay()

  local mission_widgets = view._mission_widgets
  for i = #mission_widgets, 1, -1 do
    local widget = mission_widgets[i]

    if widget and not widget.content.exit_anim_id then
      widget.content.exit_anim_id = view:_start_animation(
        "mission_exit", widget, view, nil, 1, math.random_range(0, 0.5)
      )
    end
  end
  view._selected_mission = nil
end

local function set_special_widget_positions(view, board_type)
  local custom_positions = mod.custom_mission_positions[board_type or "normal"]

  view._quickplay_widget.offset[1] = custom_positions.quickplay_mission_position[1]
  view._quickplay_widget.offset[2] = custom_positions.quickplay_mission_position[2]

  if view._flash_mission_widget then
    view._flash_mission_widget.offset[1] = custom_positions.flash_mission_position[1]
    view._flash_mission_widget.offset[2] = custom_positions.flash_mission_position[2]
  end

  if view._mission_type_selection_widget then
    view._mission_type_selection_widget.offset[1] = 0
    view._mission_type_selection_widget.offset[2] = custom_positions.quickplay_mission_position[2] + 80
  end
end

mod.queue_reset_board = function(self)
  mod.settings.reset_board = true
end

-- ##########################################################
-- #################### Hooks ###############################

-- Replace vanilla positions with grid view
mod:hook_safe(CLASS.MissionBoardView, "init", function (self)
  mod.settings.reset_board = false
  self._free_widget_positions = table.merge({}, mod.custom_mission_positions["normal"])
end)

-- Handle keybind to reset the mission board
mod:hook_safe(CLASS.MissionBoardView, "update", function (self)
  if mod.settings.reset_board then
    mod.settings.reset_board = false
    sort_missions(self)
    clear_mission_board(self)
  end
end)

-- Replace vanilla positions with grid view
mod:hook_safe(CLASS.MissionBoardView, "_setup_widgets", function (self)
  set_special_widget_positions(self, "normal")
end)

-- Replace vanilla positions with grid view
mod:hook_safe(CLASS.MissionBoardView, "_filter_mission_board", function (self, board_type)
  local custom_positions = mod.custom_mission_positions[board_type or "normal"]

  if not self._free_widget_positions.custom then
    self._free_widget_positions = table.merge({}, custom_positions)
    mod.settings.reset_board = true
  end

  set_special_widget_positions(self, board_type)
end)

-- Sort missions and clear mission widgets if necessary
mod:hook(CLASS.MissionBoardView, "_join_mission_data", function (func, self, ...)
  local should_clear = sort_missions(self) and #self._mission_widgets > 0

  if not self._backend_data.filtered_missions then
    self._backend_data.filtered_missions = {}
  end
  local result = func(self, ...)

  if should_clear and mod.settings["smg_auto_refresh"] then
    clear_mission_board(self)
  end

  set_special_widget_positions(self, "normal")
  return result
end)

-- Remove vanilla danger sort
mod:hook_origin(CLASS.MissionBoardView, "_get_free_position", function (self, preferred_index, prefered_danger_)
  local free_widget_positions = self._free_widget_positions
  local index = preferred_index or math.random(#free_widget_positions)
  local free_widget_positions_len = #free_widget_positions

  for i = 0, free_widget_positions_len do
    local rand_index = (index - 1 + 47 * i) % free_widget_positions_len + 1
    local position = free_widget_positions[rand_index]

    if position then
      free_widget_positions[rand_index] = false

      return position
    end
  end

  return false
end)

-- Rebuild mission widgets if we've cleared the board
mod:hook_safe(CLASS.MissionBoardView, "_callback_mission_widget_exit_done", function (self)
  if #self._mission_widgets == 0 and self._backend_data and #self._backend_data.missions > 0 then
    mod.settings.reset_board = false
    self._free_widget_positions = table.merge({}, mod.custom_mission_positions["normal"])

    self:_join_mission_data()
  end
end)

-- Handle potential crashes when removing widgets
mod:hook(CLASS.MissionBoardView, "_destroy_mission_widget", function (func, self, widget, ...)
  return mod:pcall(func, self, widget, ...)
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