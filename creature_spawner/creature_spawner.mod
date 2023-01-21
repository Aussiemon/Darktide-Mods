return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`creature_spawner` encountered an error loading the Darktide Mod Framework.")

		new_mod("creature_spawner", {
			mod_script       = "creature_spawner/scripts/mods/creature_spawner/creature_spawner",
			mod_data         = "creature_spawner/scripts/mods/creature_spawner/creature_spawner_data",
			mod_localization = "creature_spawner/scripts/mods/creature_spawner/creature_spawner_localization",
		})
	end,
	packages = {},
}
