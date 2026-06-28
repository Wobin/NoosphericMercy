local mod = get_mod("Noospheric Mercy")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "broadcast_enabled",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "show_others",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "rescue_marker_enabled",
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "verbose_logging",
				type = "checkbox",
				default_value = true,
			},
		},
	},
}
