extends CanvasModulate





##   1.0  = full daylight
##   0.35 = dim cave
##   0.0  = pitch black
##
.

@export_range(0.0, 2.0, 0.01) var brightness: float = 1.0:
	set(value):
		brightness = value
		_apply()

@export var tint: Color = Color(1, 1, 1):
	set(value):
		tint = value
		_apply()


func _ready() -> void:
	_apply()


func _apply() -> void:
	color = Color(tint.r * brightness, tint.g * brightness, tint.b * brightness, 1.0)
