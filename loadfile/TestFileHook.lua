local mod = get_mod("loadfile")

--[[
ItemUtils.character_level = function (item)
	local character_level = item.characterLevel or 0

	return character_level
end
--]]

mod:hook_file("scripts/utilities/items", "character_level", function(func, item, ...)
	local character_level = item.characterLevel or 0

	mod:notify("Hook is working!")
	
	return character_level
end)

local ItemUtils = require("scripts/utilities/items")

mod:echo(tostring(#mod:get_require_store("scripts/utilities/items")))
mod:echo(tostring(mod:get_require_store("scripts/utilities/items")[1] == mod:get_require_store("scripts/utilities/items")[2]))
mod:info("File Hook: character level = " .. tostring(ItemUtils.character_level({characterLevel = 10})))