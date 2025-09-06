extends Camera2D

@export var follow_speed: float = 5.0
@export var zoom_speed: float = 2.0
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0


var target: Node2D
var shake_intensity: float = 0.0
var original_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
		target = get_parent().get_node("Player")
		original_offset = offset
		var player = target
		if player:
			player.connect("on_focus_start", Callable(self, "_on_player_on_focus_start"))
			player.connect("on_focus_stop", Callable(self, "_on_player_on_focus_stop"))


func _process(delta: float) -> void:
	if shake_intensity > 0.0:
		var random_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		offset = original_offset + random_offset
	else:
		offset = original_offset


func _on_player_on_focus_start() -> void:
	shake_intensity = 2.0


func _on_player_on_focus_stop() -> void:
	shake_intensity = 0.0
