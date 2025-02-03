extends Node3D

var road_blocks = 4
var road_size = 57

var blocks_found = 1
var x_spacing = 12
var z_lanes = 4.0
var rng = RandomNumberGenerator.new()
var seen_pos = []

@export var pickup: PackedScene
@export var obstacle: PackedScene
@export var disabled = false
@onready var fx: AudioStreamPlayer3D = $AudioStreamPlayer3D

var road_1: Node3D
var road_2: Node3D
var road_3: Node3D
var road_4: Node3D
var pickups: Node
var obstacles: Node
var player: VehicleBody3D
func _ready():
	if not disabled:
		road_1 = $"../road1"
		road_2 = $"../road2"
		road_3 = $"../road3"
		road_4 = $"../road4"
		pickups = $"../../Pickups"
		obstacles = $"../../Obstacles"
		player = $"../../Player"

var gate = true
func _physics_process(_delta):
	if player != null and int(position.z - player.position.z) == -36:
		if gate:
			road_gen()
			gate = false
	elif player != null and int(position.z - player.position.z) == -35:
		gate = true
		
	
func road_gen():
	seen_pos = []
	blocks_found += 0.25
	var prev_road

	var road_order = ["Road1","Road2","Road3","Road4"]
	var roads = [road_1, road_2, road_3, road_4]
	for r in len(road_order):
		if self.is_in_group(road_order[r]):
			prev_road = roads[(r+2)%4]

	# remove existing items
	for item in prev_road.get_node("Area3D").get_overlapping_areas():
		if item.name != "barrier1" and item.name != "barrier2":
			item.queue_free()

	# spawn new items
	prev_road.position.z -= road_size * road_blocks
	var r_pos

	if rng.randi_range(0, 2):
		var new_pickup = pickup.instantiate()
		r_pos = random_position(prev_road)
		new_pickup.position.z = r_pos[0]
		new_pickup.position.x = r_pos[1]
		new_pickup.position.y = 1.5
		pickups.add_child(new_pickup)
	
	for i in rng.randi_range(int(blocks_found)-1, int(blocks_found)+1):
		var new_obstacle = obstacle.instantiate()
		r_pos = random_position(prev_road)
		new_obstacle.position.z = r_pos[0]
		new_obstacle.position.x = r_pos[1]
		new_obstacle.position.y = 1.5
		obstacles.add_child(new_obstacle)


func random_position(prev_road):
	var r_pos = []

	while true:
		var temp = []
		var positions = [-1.5, -0.5, 0.5, 1.5]
		temp.append(prev_road.position.z + (positions.pick_random() * (road_size / z_lanes)))
		temp.append(rng.randi_range(-1, 1) * x_spacing)
		if temp not in seen_pos:
			r_pos = temp
			break

	seen_pos.append(r_pos)
	return r_pos


func _on_barrier_1_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d().name == "Player":
		area.get_parent_node_3d().power -= 10
		area.get_parent_node_3d().speed = 15.0
		area.get_parent_node_3d().hit = true
		area.get_parent_node_3d().rotation.y = -25
		fx.play()

func _on_barrier_2_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d().name == "Player":
		area.get_parent_node_3d().power -= 10
		area.get_parent_node_3d().speed = 15.0
		area.get_parent_node_3d().hit = true
		area.get_parent_node_3d().rotation.y = 25
		fx.play()
