extends Area2D

# Adjust how high the lily pad launches the player (negative = up in Godot 2D)
@export var bounce_force: float = -750.0
@export var text_duration: float = 1.5

@onready var bounce_text: Label = $BounceText

func _ready() -> void:
	# Make sure the text starts hidden
	if bounce_text:
		bounce_text.hide()

func _on_body_entered(body: Node2D) -> void:
	# Check if it's your player AND they are falling onto the top of the lily pad
	if body.name == "player" and "velocity" in body and body.velocity.y >= 0:
		# Launch the player upward
		body.velocity.y = bounce_force
		show_popup_text()

func show_popup_text() -> void:
	if not bounce_text:
		return
		
	bounce_text.show()
	await get_tree().create_timer(text_duration).timeout
	bounce_text.hide()
