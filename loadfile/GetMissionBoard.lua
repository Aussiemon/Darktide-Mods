local mod = get_mod("loadfile")

local mission_board_error_text = "Failed fetching missions"
local mission_board_options = {}
local mission_board_data = {}

local function fetch_mission_board()
	local missions_future = Managers.data_service.mission_board:fetch()

	missions_future:next(function (data)
		local missions = data.missions

		for i = 1, #missions do
			local mission = missions[i]
			local text = string.format("%s. %s (chl %s res %s)", i, mission.map, mission.challenge, mission.resistance)
			mission_board_options[#mission_board_options + 1] = text
			mission_board_data[text] = mission
		end
		
		mod:dump_to_file(mission_board_options, "mission_board_options", 10)
		mod:dump_to_file(mission_board_data, "mission_board_data", 10)
		
		mod:echo("Retrieved missions.")
	end):catch(function (errors)
		mission_board_options[1] = mission_board_error_text
	
		if type(errors) == "table" then
			if errors["body"] or errors["description"] then
				mod:error("Error " .. tostring(errors["code"]) .. ": " ..
					tostring(errors["body"]) .. ", " ..
					tostring(errors["description"]))
			else
				for key, val in pairs(errors) do
					if key ~= "__traceback" and (type(val) == "string" or type(val) == "number") then
						mod:error(tostring(key) .. " : " .. tostring(val))
					end
				end
			end
		else
			mod:echo("Error: " .. tostring(errors))
		end
	end)
end

fetch_mission_board()