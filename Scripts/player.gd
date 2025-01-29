extends VehicleBody3D

@onready var head = $Pivot
@onready var camera = $Pivot/Camera3D
@onready var light1: SpotLight3D = $SpotLight3D2
@onready var light2: SpotLight3D = $SpotLight3D

@export var power = 100

const BOB_FREQ = 2.4
const BOB_AMP = 0.1
var time = 0.0

var speed
var turn_speed = 0.4
var power_steering = false
var max_speed = false

const SENSITIVITY = 0.004
const ENERGY_OPTIONS = [0,8,20]
const RANGE_OPTIONS = [0,36,4000]
const ANGLE_OPTIONS = [0,23,30]
var light_power = 0
var dist = 0
var score = 0
var light_mult = 1.0
var speed_mult = 1.0
var mult = 1.0

func _ready():
	set_lights(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	speed = 5.0
#
#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#head.rotate_y(-event.relative.x * SENSITIVITY)
		#head.rotation.y = clamp(head.rotation.y, deg_to_rad(-10), deg_to_rad(10))
		#camera.rotate_x(-event.relative.y * SENSITIVITY)
		#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-5), deg_to_rad(5))

func _physics_process(delta) -> void:
	apply_force(Vector3.DOWN * 50)
	engine_force = 200 * max((speed - linear_velocity.length()),0)
	
	if linear_velocity.length() > speed:
		brake = 10 * min((linear_velocity.length() - speed),0)
		
	steering = lerp(steering, Input.get_axis("right", "left") * turn_speed, delta*5)
	
	if power > 100:
		power = 100
	elif power <= 0:
		power = 0

	# Movement
	var input_dir := Input.get_vector("left", "right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	
	power -= 0.001 * (speed + ENERGY_OPTIONS[light_power])
	
	# Head bob
	#time += delta * 2
	#var pos = Vector3.ZERO
	#pos.y = sin(time * BOB_FREQ) * BOB_AMP
	#camera.transform.origin = pos

	#move_and_slide()
	
	dist = linear_velocity.length() * delta
	light_mult = (abs(light_power - 2) * 0.1)
	

	
	if speed == 25.0 and max_speed:
		speed_mult += 0.01 * delta
	elif speed == 25.0:
		speed_mult = ((speed / 5) * 0.1)
		max_speed = true
	else:
		speed_mult = ((speed / 5) * 0.1)
		max_speed = false
		
	mult = 1 + light_mult + snapped(speed_mult, 0.01)
	score += dist * mult


func set_lights(curr_light):
	light_power = curr_light
	light1.light_energy = ENERGY_OPTIONS[curr_light]
	light2.light_energy = ENERGY_OPTIONS[curr_light]
	light1.spot_range = RANGE_OPTIONS[curr_light]
	light2.spot_range = RANGE_OPTIONS[curr_light]
	light1.spot_angle = ANGLE_OPTIONS[curr_light]
	light2.spot_angle = ANGLE_OPTIONS[curr_light]
