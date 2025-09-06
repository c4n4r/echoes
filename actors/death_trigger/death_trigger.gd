extends Node2D


@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var parent = get_parent() as Node2D
@onready var global = Global.new()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().reload_current_scene()
