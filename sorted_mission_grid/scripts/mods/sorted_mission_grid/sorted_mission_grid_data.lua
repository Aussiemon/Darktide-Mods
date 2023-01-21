local mod = get_mod("sorted_mission_grid")

mod.custom_mission_positions = {
	{
		100,
		150,
		index = 1
	},
	{
		300,
		150,
		index = 2
	},
	{
		500,
		150,
		index = 3
	},
	{
		700,
		150,
		index = 4
	},
	{
		900,
		150,
		index = 5
	},
	{
		1100,
		150,
		index = 6
	},
	{
		100,
		350,
		index = 7
	},
	{
		300,
		350,
		index = 8
	},
	{
		500,
		350,
		index = 9
	},
	{
		700,
		350,
		index = 10
	},
	{
		900,
		350,
		index = 11
	},
	{
		1100,
		350,
		index = 12
	},
	{
		500,
		550,
		index = 13
	},
	{
		700,
		550,
		index = 14
	},
	{
		900,
		550,
		index = 15
	},
	{
		1100,
		550,
		index = 16
	},
	{
		100,
		750,
		index = 17
	},
	{
		300,
		750,
		index = 18
	},
	{
		500,
		750,
		index = 19
	},
	{
		700,
		750,
		index = 20
	},
	{
		900,
		750,
		index = 21
	},
	{
		1100,
		750,
		index = 22
	}
}

mod.circumstance_value = {
	less_resistance_01 = 1,
	default = 2,
	hunting_grounds_01 = 3,
	more_resistance_01 = 4
}

local mod_data = {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
}

return mod_data
