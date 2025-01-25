extends CharacterBody3D

@onready var head = $Pivot
@onready var camera = $Pivot/Camera3D


const LOW_GEAR = 5.0
const MID_GEAR = 15.0
const HIGH_GEAR = 25.0
var speed
var turn_speed = 15.0

const SENSITIVITY = 0.004

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	speed = LOW_GEAR

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		head.rotation.y = clamp(head.rotation.y, deg_to_rad(-30), deg_to_rad(30))
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-20), deg_to_rad(30))

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle Speed..
	if Input.is_action_pressed("low_gear"):
		speed = LOW_GEAR
	elif Input.is_action_pressed("mid_gear"):
		speed = MID_GEAR
	elif Input.is_action_pressed("high_gear"):
		speed = HIGH_GEAR

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * turn_speed
	else:
		velocity.x = move_toward(velocity.x, 0, turn_speed)
	velocity.z = -1 * speed

	move_and_slide()
