return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`bot_spawner` encountered an error loading the Darktide Mod Framework.")

		new_mod("bot_spawner", {
			mod_script       = "bot_spawner/scripts/mods/bot_spawner/bot_spawner",
			mod_data         = "bot_spawner/scripts/mods/bot_spawner/bot_spawner_data",
			mod_localization = "bot_spawner/scripts/mods/bot_spawner/bot_spawner_localization",
		})
	end,
	packages = {},
}
