extends Node2D

@onready var player = $Present/Player

func _ready() -> void:
	var echo = Echo.new(
		get_tree().current_scene.get_node("FrontMask") as ColorRect,
		player,
		25.0)
	player.echo_instance = echo
	add_child(echo)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
