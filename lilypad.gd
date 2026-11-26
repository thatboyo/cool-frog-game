extends Area2D


@export var bounce_force: float = -750.0
@export var text_duration: float = 1.5


	

func _on_body_entered(body: Node2D) -> void:
	
	if body.name == "player" and "velocity" in body and body.velocity.y >= 0:
		
		body.velocity.y = bounce_force
