return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`afk` encountered an error loading the Darktide Mod Framework.")

		new_mod("afk", {
			mod_script       = "afk/scripts/mods/afk/afk",
			mod_data         = "afk/scripts/mods/afk/afk_data",
			mod_localization = "afk/scripts/mods/afk/afk_localization",
		})
	end,
	packages = {},
}
