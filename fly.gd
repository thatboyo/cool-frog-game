extends Area2D

@export var respawn_point: Marker2D
@export var you_died_ui: CanvasLayer
@export var respawn_delay: float = 1.0

var is_respawning: bool = false

func _on_body_entered(body: Node2D) -> void:

	if body.name == "player" and not is_respawning:
		trigger_death(body)

func trigger_death(player_node: Node2D) -> void:
	is_respawning = true
	

	player_node.hide()
	player_node.set_physics_process(false)
	

	if you_died_ui:
		you_died_ui.show()
		

	await get_tree().create_timer(respawn_delay).timeout
	
	
	if you_died_ui:
		you_died_ui.hide()
		
	if respawn_point:
		player_node.global_position = respawn_point.global_position
		
	if "velocity" in player_node:
		player_node.velocity = Vector2.ZERO
		
	# Re-enable the player
	player_node.show()
	player_node.set_physics_process(true)
	is_respawning = false
