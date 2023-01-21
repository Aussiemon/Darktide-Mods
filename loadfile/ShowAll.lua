local mod = get_mod("loadfile")

local seen_units = {}

local world = Managers and Managers.world and Managers.world:world("level_world")
if world then
	local unit_set_unit_visibility = Unit.set_unit_visibility
	local world_units = World.units
	
	for _, unit in ipairs(world_units(world)) do
		unit_set_unit_visibility(unit, true)
	end
end