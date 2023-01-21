--[[
	Load a file from the mods/loadfile folder
--]]

local mod_name = "loadfile"
local mod = get_mod(mod_name)

-- ##########################################################
-- ################## Variables #############################

local lua_file_extension = ".lua"

-- ##########################################################
-- ################## Functions #############################

mod:command("load", mod:localize("command_description"), function(...) mod:load(...) end)

mod.load = function(self, ...)
	-- Process arguments.
	local args = {...}
	if #args > 0 then

		-- Process/format arguments into a new message
		local new_file_name = ""
		for _, value in pairs(args) do

			if type(value) == "string" then
				new_file_name = new_file_name .. value

			elseif type(value) == "table" then
				for _, value_value in pairs(value) do
					if type(value_value) == "string" then
						new_file_name = new_file_name .. value_value
					end
				end
			end
		end
		
		-- Check for .lua extension
		local trim_point = string.find(new_file_name, lua_file_extension)
		if trim_point then
			new_file_name = string.sub(new_file_name, 1, (trim_point-1)) -- Cut off extension
		end
		
		-- Attempt to load file
		if mod:io_exec(mod_name, new_file_name) then
			mod:info("Loaded " .. new_file_name .. " successfully.")
		end
	else
		mod:notify(mod:localize("no_filename"))
	end
end

-- ##########################################################
-- #################### Hooks ###############################

-- ##########################################################
-- ################### Callback #############################

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################
