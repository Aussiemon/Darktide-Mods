local mod = get_mod("loadfile")

--[[
ItemUtils.character_level = function (item)
  local character_level = item.characterLevel or 0

  return character_level
end
--]]

mod:hook_require("scripts/utilities/items", function(instance)
  mod:hook_safe(instance, "character_level", function(item, ...)
    mod:notify("Hook is working!")
  end)
end)

local ItemUtils = require("scripts/utilities/items")

mod:echo(tostring(#mod:get_require_store("scripts/utilities/items")))
mod:echo(tostring(mod:get_require_store("scripts/utilities/items")[1] == mod:get_require_store("scripts/utilities/items")[2]))
mod:echo("File Hook: character level = " .. tostring(ItemUtils.character_level({characterLevel = 10})))