local mod = get_mod("loadfile")

--[[
ItemUtils.character_level = function (item)
	local character_level = item.characterLevel or 0

	return character_level
end
--]]

mod:hook_safe(CLASS.StoreItemDetailView, "destroy", function()
	mod:echo("Hook is working!")
end)