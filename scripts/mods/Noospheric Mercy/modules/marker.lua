local mod = get_mod("Noospheric Mercy")
local Phrases = mod:io_dofile("Noospheric Mercy/scripts/mods/Noospheric Mercy/modules/phrases")

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")

local math_floor = math.floor

local Marker = {}

Marker.TYPE = "noospheric_mercy_rescue"

local ICON = "content/ui/materials/hud/interactions/icons/pocketable_medkit"
local ARROW = "content/ui/materials/hud/interactions/frames/direction"
local ICON_SIZE = { 144, 144 }
local ARROW_SIZE = { 210, 210 }

local COLOR_CERTAIN = { 255, 80, 235, 90 }
local COLOR_GUESS = { 255, 255, 150, 30 }

function Marker.color_for(confidence)
	if confidence == Phrases.CONFIDENCE_GUESS then
		return COLOR_GUESS
	end

	return COLOR_CERTAIN
end

local function apply_color(dst, src)
	dst[1], dst[2], dst[3], dst[4] = src[1], src[2], src[3], src[4]
end

local template = {
	name = Marker.TYPE,
	size = { 100, 100 },
	unit_node = "ui_interaction_marker",
	position_offset = { 0, 0, 1.8 },
	using_smart_tag_system = false,
	max_distance = 200,
	screen_clamp = true,
	screen_margins = {
		down = 0.23148148148148148,
		left = 0.234375,
		right = 0.234375,
		up = 0.23148148148148148,
	},
	scale_settings = {
		distance_max = 30,
		distance_min = 5,
		scale_from = 0.6,
		scale_to = 1,
	},
}

template.create_widget_defintion = function(template, scenegraph_id)
	local font = UIFontSettings.hud_body

	return UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "icon",
			value = ICON,
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = ICON_SIZE,
				offset = { 0, -10, 1 },
				color = { 255, 255, 255, 255 },
			},
			visibility_function = function(content, style)
				return not content.is_clamped
			end,
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			value = ARROW,
			value_id = "arrow",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = ARROW_SIZE,
				offset = { 0, 0, 1 },
				color = { 255, 255, 255, 255 },
			},
			visibility_function = function(content, style)
				return content.is_clamped
			end,
			change_function = function(content, style)
				style.angle = content.angle
			end,
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "-",
			value_id = "text",
			style = {
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				text_vertical_alignment = "top",
				offset = { 0, 26, 2 },
				font_type = font.font_type,
				font_size = font.font_size,
				text_color = { 255, 255, 255, 255 },
				size = { 200, 20 },
			},
			visibility_function = function(content, style)
				return content.distance ~= nil and content.distance >= 8
			end,
		},
	}, scenegraph_id)
end

template.update_function = function(parent, ui_renderer, widget, marker, template, dt, t)
	local content = widget.content
	local style = widget.style
	local data = marker.data
	local color = data and data.color

	if color then
		apply_color(style.icon.color, color)
		apply_color(style.arrow.color, color)
	end

	local distance = content.distance
	local meters = (distance and distance > 1) and math_floor(distance) or nil

	if meters ~= marker._nm_last_m then
		marker._nm_last_m = meters
		content.text = meters and (meters .. "m") or ""
	end

	return false
end

function Marker.register()
	mod:hook_safe("HudElementWorldMarkers", "init", function(self)
		if self._marker_templates then
			self._marker_templates[Marker.TYPE] = template
		end
	end)
end

return Marker
