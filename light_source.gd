extends PointLight2D


##
## Tune it in the Inspector:
##   radius     - how far the light reaches, in pixels
##   brightness - how strong it is
##   light_color- the light's colour

@export var radius: float = 220.0:
	set(value):
		radius = value
		_update_scale()

@export var brightness: float = 1.0:
	set(value):
		brightness = value
		energy = value

@export var light_color: Color = Color(1.0, 0.88, 0.6):
	set(value):
		light_color = value
		color = value


func _ready() -> void:
	_apply()


func _apply() -> void:
	energy = brightness
	color = light_color
	_update_scale()


func _update_scale() -> void:
	if texture == null:
		return
	var longest := float(max(texture.get_width(), texture.get_height()))
	if longest > 0.0:
		
		texture_scale = (radius * 2.0) / longest
