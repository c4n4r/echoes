extends Node

class_name Global

@onready var current_scene: Node = get_tree().current_scene
@onready var spawn_position: Node2D = current_scene.get_node("Spawn") as Node2D
var is_game_paused: bool = false


func pause_game() -> void:
	is_game_paused = true
	get_tree().paused = true


func resume_game() -> void:
	is_game_paused = false
	get_tree().paused = false


func restart_level() -> void:
	get_tree().reload_current_scene()
