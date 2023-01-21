return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`hungry_hungry` encountered an error loading the Darktide Mod Framework.")

		new_mod("hungry_hungry", {
			mod_script       = "hungry_hungry/scripts/mods/hungry_hungry/hungry_hungry",
			mod_data         = "hungry_hungry/scripts/mods/hungry_hungry/hungry_hungry_data",
			mod_localization = "hungry_hungry/scripts/mods/hungry_hungry/hungry_hungry_localization",
		})
	end,
	packages = {},
}
