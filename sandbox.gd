extends Node2D

@onready var front_mask := $FrontMask
@export var reveal_radius: float = 200.0
var shader_material: ShaderMaterial

func _ready():
	shader_material = front_mask.material as ShaderMaterial

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if Input.is_action_pressed("switch"):
		print("Switching shape")
		shader_material.set_shader_parameter("shape_type", 1) # rectangle
	else:
		shader_material.set_shader_parameter("shape_type", 2) # circle

	shader_material.set_shader_parameter("mouse_pos", mouse_pos)
	shader_material.set_shader_parameter("radius", reveal_radius)

func make_radius_evolve(target_radius: float, duration: float) -> void:
	var initial_radius = reveal_radius
	var time_passed = 0.0
	while time_passed < duration:
		var t = time_passed / duration
		reveal_radius = lerp(initial_radius, target_radius, t)
		time_passed += get_process_delta_time()
		await get_tree().process_frame
	reveal_radius = target_radius
