local mod = get_mod("loadfile")

mod:notify("Pre: " .. type(CLASS.StoreItemDetailView))  -- = "string"
--require("scripts/ui/views/store_item_detail_view/store_item_detail_view")
mod:notify("Post: " .. type(CLASS.StoreItemDetailView)) -- = "table"