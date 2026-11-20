extends Area2D



##  Set `cutscene_scene` and
## `next_level` in the Inspector 

@export_file("*.tscn") var cutscene_scene: String = "res://cutscene.tscn"
@export_file("*.tscn") var next_level: String = "res://level2.tscn"

@export var spawn_point_name: String = "spawnPoint"

var _triggered := false


func _on_body_entered(body: Node2D) -> void:
	if _triggered or body.name != "player":
		return
	_triggered = true
	Transition.start_cutscene(cutscene_scene, next_level, spawn_point_name)
