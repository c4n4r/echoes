class_name Echo
extends Node2D

@export var front_mask: ColorRect
@export var actor: Node2D
@export var reveal_radius: float = 15.0
@export var _roam_time: float = 0.0

var shader_material: ShaderMaterial

func _init(
	mask: ColorRect,
	node: Node2D,
	radius: float = 15.0
) -> void:
	self.front_mask = mask
	self.actor = node
	self.reveal_radius = radius


func _ready():
	if front_mask:
		shader_material = front_mask.material as ShaderMaterial
		if shader_material:
			shader_material.set_shader_parameter("radius", reveal_radius)
			shader_material.set_shader_parameter("active", true)
	# Initialize time for roaming
	self._roam_time = 0.0

func _process(_delta):
	if shader_material:
		_make_echo_roam(_delta)
		shader_material.set_shader_parameter("radius", reveal_radius)


func _make_echo_roam(_delta: float) -> void:
	# make the echo slowly roam around the actor
	var roam_radius = reveal_radius * 0.2
	var roam_speed = 0.7
	self._roam_time += _delta
	var offset = Vector2(
		roam_radius * sin(self._roam_time * roam_speed),
		roam_radius * cos(self._roam_time * roam_speed)
	)
	if shader_material:
		shader_material.set_shader_parameter("mouse_pos", actor.get_global_transform_with_canvas().origin + offset)


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
