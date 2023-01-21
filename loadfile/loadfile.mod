local directory_name = "loadfile"
local file_name = "loadfile"

local main_script_path = directory_name.."/scripts/mods/"..directory_name.."/"..file_name

print("'"..file_name.."' Mod loading...")

local fassert = fassert
local rawget = rawget
local _G = _G

local ret = {
	run = function()
		if rawget(_G, "new_mod") then
			local mod = new_mod(file_name, {
				mod_script       = main_script_path,
				mod_data         = main_script_path .. "_data",
				mod_localization = main_script_path .. "_localization"
			})
		else
			fassert(false, file_name.." encountered an error loading the Darktide Mod Framework.")
		end
	end,
	packages = {
		"resource_packages/"..directory_name.."/"..file_name
	},
}
return ret