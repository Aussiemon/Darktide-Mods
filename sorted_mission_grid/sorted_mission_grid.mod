return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`sorted_mission_grid` encountered an error loading the Darktide Mod Framework.")

		new_mod("sorted_mission_grid", {
			mod_script       = "sorted_mission_grid/scripts/mods/sorted_mission_grid/sorted_mission_grid",
			mod_data         = "sorted_mission_grid/scripts/mods/sorted_mission_grid/sorted_mission_grid_data",
			mod_localization = "sorted_mission_grid/scripts/mods/sorted_mission_grid/sorted_mission_grid_localization",
		})
	end,
	packages = {},
}
