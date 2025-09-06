extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var echo = Echo.new(
		get_tree().current_scene.get_node("FrontMask") as ColorRect,
		self as Node2D,
		50.0
	)
	print("Adding echo to monolith", echo)
	add_child(echo)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
