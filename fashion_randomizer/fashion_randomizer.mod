return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`fashion_randomizer` encountered an error loading the Darktide Mod Framework.")

		new_mod("fashion_randomizer", {
			mod_script       = "fashion_randomizer/scripts/mods/fashion_randomizer/fashion_randomizer",
			mod_data         = "fashion_randomizer/scripts/mods/fashion_randomizer/fashion_randomizer_data",
			mod_localization = "fashion_randomizer/scripts/mods/fashion_randomizer/fashion_randomizer_localization",
		})
	end,
	packages = {},
}
