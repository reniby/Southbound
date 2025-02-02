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
var turn_speed = 0.2
var power_steering = false
var max_speed = false
var hit = false

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
	set_lights(1)
	speed = 5.0
#
#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#head.rotate_y(-event.relative.x * SENSITIVITY)
		#head.rotation.y = clamp(head.rotation.y, deg_to_rad(-10), deg_to_rad(10))
		#camera.rotate_x(-event.relative.y * SENSITIVITY)
		#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-5), deg_to_rad(5))

func _physics_process(delta) -> void:
	apply_force(Vector3.DOWN * 100)
	
	engine_force = 200 * max((speed - linear_velocity.length()),0.0)
	
	if linear_velocity.length() > speed and not hit:
		brake = 10 * min((linear_velocity.length() - speed),0)
	elif linear_velocity.length() > speed and hit:
		center_of_mass = Vector3(0,0,0.2)
		brake = 50
	elif linear_velocity.length() <= speed and hit:
		center_of_mass = Vector3(0,0,-1.5)
		hit = false
		
	steering = lerp(steering, Input.get_axis("right", "left") * turn_speed, delta*3)
	
	if power > 100:
		power = 100
	elif power <= 0:
		power = 0

	power -= 0.01 * (speed + ENERGY_OPTIONS[light_power])
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

func _integrate_forces(state):
	rotation.y = clamp(rotation.y, deg_to_rad(-40.0), deg_to_rad(40.0))

func set_lights(curr_light):
	light_power = curr_light
	light1.light_energy = ENERGY_OPTIONS[curr_light]
	light2.light_energy = ENERGY_OPTIONS[curr_light]
	light1.spot_range = RANGE_OPTIONS[curr_light]
	light2.spot_range = RANGE_OPTIONS[curr_light]
	light1.spot_angle = ANGLE_OPTIONS[curr_light]
	light2.spot_angle = ANGLE_OPTIONS[curr_light]
