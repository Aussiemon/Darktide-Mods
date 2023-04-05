local mod = get_mod("afk")

-- ##########################################################
-- ################## Variables #############################

mod.storage  = mod:persistent_table("storage")
mod.storage.blocked_check_count = mod.storage.blocked_check_count or 0

mod.settings = mod:persistent_table("settings")

-- ##########################################################
-- ################## Functions #############################

local function initialize_settings_cache()
  mod.settings["block_check_limit"] = mod:get("block_check_limit")
end
initialize_settings_cache()

local function block_afk_popup()
  if Managers.state and Managers.state.game_session then
    mod.storage.blocked_check_count = mod.storage.blocked_check_count + 1
    Managers.state.game_session:send_rpc_server("rpc_report_menu_activity")
  end
end

local function reset_afk_count()
  mod.storage.blocked_check_count = 0
end

-- ##########################################################
-- #################### Hooks ###############################

mod:hook(CLASS.AFKChecker, "rpc_enable_inactivity_warning", function (func, self, ...)

  -- Report menu activity to the server until the limit is reached
  if (not self._is_server) and mod.storage.blocked_check_count <= mod.settings["block_check_limit"] then
    block_afk_popup()

  -- Otherwise allow the warning
  else
    reset_afk_count()
    return func(self, ...)
  end
end)

-- ##########################################################
-- ################# Callbacks ##############################

-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
  mod.storage.blocked_check_count = 0
end

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_id)
  mod.settings[setting_id] = mod:get(setting_id)
end

-- ##########################################################
-- ################### Script ###############################

-- ##########################################################