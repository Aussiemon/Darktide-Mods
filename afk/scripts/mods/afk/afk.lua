local mod = get_mod("afk")

-- ##########################################################
-- ################## Variables #############################

local _persistent_storage = mod:persistent_table("persistent_storage")

-- ##########################################################
-- ################## Functions #############################

-- ##########################################################
-- #################### Hooks ###############################

mod:hook(AFKChecker, "rpc_enable_inactivity_warning", function (func, self, ...)

  -- If the limit is reached, we allow the warning
  if _persistent_storage.blocked_check_count > mod:get("block_check_limit") then
    
    _persistent_storage.blocked_check_count = 0
    return func(self, ...)

  -- Otherwise report menu activity to the server to prevent the warning
  else
    _persistent_storage.blocked_check_count = _persistent_storage.blocked_check_count + 1
    
    if (not self._is_server) and Managers.state and Managers.state.game_session then
      Managers.state.game_session:send_rpc_server("rpc_report_menu_activity")
    end
  end
end)

-- ##########################################################
-- ################### Script ###############################

_persistent_storage.blocked_check_count = _persistent_storage.blocked_check_count or 0

-- ##########################################################