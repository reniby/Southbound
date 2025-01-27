extends CharacterBody3D

@onready var head = $Pivot
@onready var camera = $Pivot/Camera3D
@onready var light1: SpotLight3D = $SpotLight3D2
@onready var light2: SpotLight3D = $SpotLight3D

@export var power = 100

const BOB_FREQ = 2.4
const BOB_AMP = 0.1
var time = 0.0

const LOW_GEAR = 5.0
const MID_GEAR = 15.0
const HIGH_GEAR = 25.0
var speed
var turn_speed = 15.0

const SENSITIVITY = 0.004
const ENERGY_OPTIONS = [0,8,20]
const RANGE_OPTIONS = [0,36,4000]
const ANGLE_OPTIONS = [0,23,30]
var curr_light

func _ready():
	curr_light = 0
	light1.light_energy = ENERGY_OPTIONS[curr_light]
	light2.light_energy = ENERGY_OPTIONS[curr_light]
	light1.spot_range = RANGE_OPTIONS[curr_light]
	light2.spot_range = RANGE_OPTIONS[curr_light]
	light1.spot_angle = ANGLE_OPTIONS[curr_light]
	light2.spot_angle = ANGLE_OPTIONS[curr_light]
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	speed = LOW_GEAR

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		head.rotation.y = clamp(head.rotation.y, deg_to_rad(-10), deg_to_rad(10))
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-5), deg_to_rad(5))

func _physics_process(delta) -> void:
	if power > 100:
		power = 100
	elif power <= 0:
		power = 0
		print("you lose")

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Speed
	if Input.is_action_pressed("low_gear"):
		speed = LOW_GEAR
	elif Input.is_action_pressed("mid_gear"):
		speed = MID_GEAR
	elif Input.is_action_pressed("high_gear"):
		speed = HIGH_GEAR
		
	if Input.is_action_just_released("light"):
		curr_light = (curr_light + 1) % 3 
		light1.light_energy = ENERGY_OPTIONS[curr_light]
		light2.light_energy = ENERGY_OPTIONS[curr_light]
		light1.spot_range = RANGE_OPTIONS[curr_light]
		light2.spot_range = RANGE_OPTIONS[curr_light]
		light1.spot_angle = ANGLE_OPTIONS[curr_light]
		light2.spot_angle = ANGLE_OPTIONS[curr_light]

	# Movement
	var input_dir := Input.get_vector("left", "right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	
	if direction.x:
		velocity.x = direction.x * turn_speed
	else:
		velocity.x = move_toward(velocity.x, 0, turn_speed)
	velocity.z = -1 * speed
	power -= 0.001 * (speed + ENERGY_OPTIONS[curr_light])
	
	# Head bob
	time += delta * 2
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	camera.transform.origin = pos

	move_and_slide()
