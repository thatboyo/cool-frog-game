extends Control



@export var duration: float = 5.0  # seconds before auto-advancing 

var _advancing := false


func _ready() -> void:
	if duration > 0.0:
		await get_tree().create_timer(duration).timeout
		_advance()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") or event.is_action_pressed("ui_accept"):
		_advance()


func _advance() -> void:
	if _advancing:
		return
	_advancing = true
	await Transition.finish_cutscene()
