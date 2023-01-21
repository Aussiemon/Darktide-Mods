local mod = get_mod("sorted_mission_grid")

-- ##########################################################
-- ################## Variables #############################

-- ##########################################################
-- ################## Functions #############################

local mission_sort_func = function(k1, k2)
  
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

-- ##########################################################
-- #################### Hooks ###############################

mod:hook_safe(CLASS.MissionBoardView, "init", function (self)

  -- Replace vanilla positions with grid view
  self._free_widget_positions = table.merge({}, mod.custom_mission_positions)
end)

mod:hook(CLASS.MissionBoardView, "_join_mission_data", function (func, self, ...)

  -- Sort missions, then update each display index
  table.sort(self._backend_data.missions, mission_sort_func)
  for i = 1, #self._backend_data.missions do
    if self._backend_data.missions[i] then
      self._backend_data.missions[i].displayIndex = i
    end
  end

  return func(self, ...)
end)

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
