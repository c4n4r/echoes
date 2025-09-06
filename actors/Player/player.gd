extends CharacterBody2D

const SPEED = 100.0 * 60.0
const JUMP_VELOCITY = -325.0 * 60.0
const MAX_FOCUS_RADIUS = 400.0
const FOCUS_GROWTH_RATE = 200.0

@onready var animated_sprite: AnimatedSprite2D = $Anims
@onready var player_camera: Camera2D = $Camera2D
@onready var front_mask: ColorRect = get_tree().current_scene.get_node("FrontMask")
@export var is_echo_activated := false

var is_focusing := false
var focus_radius := 0.0
var echo_instance: Echo = null

func _ready() -> void:
	echo_instance = Echo.new(
		front_mask,
		self,
		25.0
	)
	add_child(echo_instance)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump(delta)
	handle_movement(delta)
	handle_focus(delta)
	move_and_slide()
	update_animation()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * delta

func handle_movement(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * delta
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) * delta

func update_animation() -> void:
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("InAir")
		else:
			animated_sprite.play("Falling")
	else:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			animated_sprite.play("Run")
		else:
			animated_sprite.play("Idle")

func handle_focus(delta: float) -> void:
	if Input.is_action_pressed("Focus"):
		if not is_focusing:
			start_focus()
		else:
			# grandir l'echo tant que le focus est maintenu et pas au max
			if focus_radius < MAX_FOCUS_RADIUS:
				var new_radius = min(focus_radius + FOCUS_GROWTH_RATE * delta, MAX_FOCUS_RADIUS)
				echo_instance.make_radius_grow(focus_radius, new_radius, delta)
				focus_radius = new_radius
			else:
				stop_focus()
	else:
		if is_focusing:
			stop_focus()

func start_focus() -> void:
	is_focusing = true
	is_echo_activated = true
	focus_radius = 0.0
	
	echo_instance = Echo.new(
		front_mask,
		self,
		15.0
	)
	add_child(echo_instance)
	# commence à grandir
	echo_instance.make_radius_grow(0.0, FOCUS_GROWTH_RATE * get_physics_process_delta_time(), get_physics_process_delta_time())
	focus_radius = FOCUS_GROWTH_RATE * get_physics_process_delta_time()

func stop_focus() -> void:
	is_focusing = false
	is_echo_activated = false
	if echo_instance:
		echo_instance.make_radius_grow(FOCUS_GROWTH_RATE * get_physics_process_delta_time(), 0.0, get_physics_process_delta_time() / 2)
