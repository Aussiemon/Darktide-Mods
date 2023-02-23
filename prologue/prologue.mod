return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`prologue` encountered an error loading the Darktide Mod Framework.")

		new_mod("prologue", {
			mod_script       = "prologue/scripts/mods/prologue/prologue",
			mod_data         = "prologue/scripts/mods/prologue/prologue_data",
			mod_localization = "prologue/scripts/mods/prologue/prologue_localization",
		})
	end,
	packages = {},
}
