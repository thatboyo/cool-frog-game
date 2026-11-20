extends CanvasLayer

## Autoload ("Transition") that fades the screen to/from black and swaps scenes.
##
## It powers the portal flow:  fade to black -> load the cutscene -> fade in,
## then (when the cutscene is done) fade to black -> load the next level -> fade in.
##
## You can call it from anywhere, e.g. `Transition.go_to_scene("res://level2.tscn")`.

const FADE_DURATION := 0.6

var _rect: ColorRect
var _busy := false

## The level the portal wants to reach *after* the cutscene finishes.
var next_scene_path: String = ""
## Name of the Marker2D in the next level where the player should appear.
var next_spawn_name: String = ""


func _ready() -> void:
	# Draw above everything and keep animating even while the game is paused.
	layer = 128
	process_mode = Node.PROCESS_MODE_ALWAYS

	_rect = ColorRect.new()
	_rect.name = "FadeRect"
	_rect.color = Color(0, 0, 0, 1)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.modulate = Color(1, 1, 1, 0)  # start fully transparent
	add_child(_rect)


## Fade the screen to solid black.
func fade_out(duration: float = FADE_DURATION) -> void:
	_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.tween_property(_rect, "modulate:a", 1.0, duration)
	await tween.finished


## Fade the screen back to transparent.
func fade_in(duration: float = FADE_DURATION) -> void:
	var tween := create_tween()
	tween.tween_property(_rect, "modulate:a", 0.0, duration)
	await tween.finished
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE


## Change to another scene and wait until it has actually entered the tree.
func _swap_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	await get_tree().process_frame


## Portal step 1: fade out, load the cutscene, fade back in.
## Remembers where the trip ends so the cutscene can finish it.
## `spawn_name` is the Marker2D in the next level where the player should appear.
func start_cutscene(cutscene_path: String, next_level_path: String, spawn_name: String = "") -> void:
	if _busy:
		return
	_busy = true
	next_scene_path = next_level_path
	next_spawn_name = spawn_name
	await fade_out()
	await _swap_scene(cutscene_path)
	await fade_in()
	_busy = false


## Portal step 2: called by the cutscene once it is finished.
func finish_cutscene() -> void:
	if next_scene_path.is_empty():
		push_warning("Transition.finish_cutscene() called but no next scene was set.")
		return
	await fade_out()
	await _swap_scene(next_scene_path)
	_place_player_at_spawn(next_spawn_name)
	await fade_in()


## Move the player onto the named Marker2D in the current scene (no-op if either
## is missing). Called after a scene change so the player appears at the spawn.
func _place_player_at_spawn(spawn_name: String) -> void:
	if spawn_name.is_empty():
		return
	var scene := get_tree().current_scene
	if scene == null:
		return
	var spawn := scene.find_child(spawn_name, true, false)
	if spawn == null:
		push_warning("Transition: no node named '%s' in the new scene." % spawn_name)
		return
	var player := scene.find_child("player", true, false)
	if player == null:
		push_warning("Transition: no 'player' node in the new scene to move to spawn.")
		return
	if player is Node2D and spawn is Node2D:
		(player as Node2D).global_position = (spawn as Node2D).global_position
	if "velocity" in player:
		player.velocity = Vector2.ZERO


## Simple reusable fade + scene change to any scene.
func go_to_scene(path: String) -> void:
	if _busy:
		return
	_busy = true
	await fade_out()
	await _swap_scene(path)
	await fade_in()
	_busy = false