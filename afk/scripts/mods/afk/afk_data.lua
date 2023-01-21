local mod = get_mod("afk")

return {
  name = mod:localize("mod_name"),
  description = mod:localize("mod_description"),
  is_togglable = true,
  options = {
    widgets = {
      {
        setting_id    = "block_check_limit",
        type          = "numeric",
        default_value = 3,
        range         = {1, 10},
      },
    }
  }
}
