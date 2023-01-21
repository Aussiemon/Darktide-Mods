return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`reroll_until_rarity` encountered an error loading the Darktide Mod Framework.")

		new_mod("reroll_until_rarity", {
			mod_script       = "reroll_until_rarity/scripts/mods/reroll_until_rarity/reroll_until_rarity",
			mod_data         = "reroll_until_rarity/scripts/mods/reroll_until_rarity/reroll_until_rarity_data",
			mod_localization = "reroll_until_rarity/scripts/mods/reroll_until_rarity/reroll_until_rarity_localization",
		})
	end,
	packages = {},
}
