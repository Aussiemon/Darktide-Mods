return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`camera_freeflight` encountered an error loading the Darktide Mod Framework.")

		new_mod("camera_freeflight", {
			mod_script       = "camera_freeflight/scripts/mods/camera_freeflight/camera_freeflight",
			mod_data         = "camera_freeflight/scripts/mods/camera_freeflight/camera_freeflight_data",
			mod_localization = "camera_freeflight/scripts/mods/camera_freeflight/camera_freeflight_localization",
		})
	end,
	packages = {},
}
