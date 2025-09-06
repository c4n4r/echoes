extends StaticBody2D


@export var from = Vector2.ZERO
@export var to = Vector2.ZERO
@export var SPEED: float = 100.0
@export var pause_time: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = from
	_move_platform(from, to)

func _move_platform(start_pos: Vector2, end_pos: Vector2) -> void:
	var duration = start_pos.distance_to(end_pos) / SPEED
	var tween = create_tween()
	tween.tween_property(self, "position", end_pos, duration)
	tween.tween_callback(Callable(self, "_on_platform_reached").bind(end_pos, start_pos))
	tween.tween_interval(pause_time)

func _on_platform_reached(current: Vector2, next: Vector2) -> void:
	_move_platform(current, next)
