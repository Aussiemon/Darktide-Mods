local mod_name = "loadfile"
local mod = get_mod(mod_name)

local mod_data = {
	name = "Loadfile",
	description = mod:localize("mod_description"),
	is_togglable = false,
	is_mutator = false,
	mutator_settings = {}
}

mod_data.options = {}

return mod_data
