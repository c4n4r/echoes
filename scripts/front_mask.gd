extends ColorRect

var player: CharacterBody2D
var player_camera: Camera2D = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().current_scene.get_node("Present/Player") as CharacterBody2D
	player_camera = player.get_node("Camera2D") as Camera2D
	size = player_camera.get_viewport_rect().size
	position = player_camera.get_global_position() - size / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_camera:
		size = player_camera.get_viewport_rect().size
		position = player_camera.get_global_position() - size / 2
