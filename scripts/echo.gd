class_name Echo
extends Node2D

@export var front_mask: ColorRect
@export var actor: Node2D
@export var reveal_radius: float = 50.0

var shader_material: ShaderMaterial

func _ready():
	if front_mask:
		shader_material = front_mask.material as ShaderMaterial

func _process(_delta):
	if shader_material:
		shader_material.set_shader_parameter("mouse_pos", actor.get_global_transform_with_canvas().origin)
		shader_material.set_shader_parameter("radius", reveal_radius)


func set_reveal_radius(radius: float) -> void:
	reveal_radius = radius
	if shader_material:
		shader_material.set_shader_parameter("radius", reveal_radius)

func make_radius_grow(from: float, to: float, duration: float) -> void:
	reveal_radius = from
	set_reveal_radius(reveal_radius)
	make_radius_evolve(to, duration)


func make_radius_evolve(target_radius: float, duration: float) -> void:
	var initial_radius = reveal_radius
	var time_passed = 0.0
	while time_passed < duration:
		var t = time_passed / duration
		reveal_radius = lerp(initial_radius, target_radius, t)
		time_passed += get_process_delta_time()
		await get_tree().process_frame
	reveal_radius = target_radius
