extends ColorRect

var player: CharacterBody2D
var player_camera: Camera2D

func _ready() -> void:
	player = get_tree().current_scene.get_node("Present/Player") as CharacterBody2D
	player_camera = player.get_node("Camera2D") as Camera2D
	update_mask()
	# Connect to camera's position changed signal if available
	if player_camera.has_signal("position_changed"):
		player_camera.connect("position_changed", Callable(self, "update_mask"))
	# Connect to viewport resize if needed
	get_viewport().connect("size_changed", Callable(self, "update_mask"))

func _process(delta: float) -> void:
	update_mask()

func update_mask() -> void:
	if player_camera:
		size = get_viewport().size
		position = player_camera.global_position - size / 2
