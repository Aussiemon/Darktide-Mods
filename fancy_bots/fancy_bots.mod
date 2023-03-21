return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`fancy_bots` encountered an error loading the Darktide Mod Framework.")

		new_mod("fancy_bots", {
			mod_script       = "fancy_bots/scripts/mods/fancy_bots/fancy_bots",
			mod_data         = "fancy_bots/scripts/mods/fancy_bots/fancy_bots_data",
			mod_localization = "fancy_bots/scripts/mods/fancy_bots/fancy_bots_localization",
		})
	end,
	packages = {},
}
