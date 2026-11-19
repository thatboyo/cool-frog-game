extends Area2D

# Adjust how high the lily pad launches the player (negative = up in Godot 2D)
@export var bounce_force: float = -750.0
@export var text_duration: float = 1.5


	# Make sure the text starts hidden

func _on_body_entered(body: Node2D) -> void:
	# Check if it's your player AND they are falling onto the top of the lily pad
	if body.name == "player" and "velocity" in body and body.velocity.y >= 0:
		# Launch the player upward
		body.velocity.y = bounce_force
