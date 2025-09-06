extends Node2D


@export var echo_radius: float = 50.0
@export var echo_roam_speed: float = 0.7
@export var echo_roam_radius: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var echo = Echo.new(
		get_tree().current_scene.get_node("FrontMask") as ColorRect,
		self as Node2D,
		echo_radius
	)
	echo.roam_speed = echo_roam_speed
	echo.roam_radius = echo_roam_radius
	print("Adding echo to monolith", echo)
	add_child(echo)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
