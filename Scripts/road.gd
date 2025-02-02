extends Node3D

@onready var road_1: Node3D = $"../road1"
@onready var road_2: Node3D = $"../road2"
@onready var road_3: Node3D = $"../road3"
@onready var road_4: Node3D = $"../road4"
@onready var pickups: Node = $"../../Pickups"
@onready var obstacles: Node = $"../../Obstacles"

@export var pickup: PackedScene
@export var obstacle: PackedScene

@onready var player: VehicleBody3D = $"../../Player"
var road_blocks = 4
var road_size = 57

var blocks_found = 1
var x_spacing = 12
var z_lanes = 4
var rng = RandomNumberGenerator.new()
var seen_pos = []

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d().name == "Player":
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
			item.queue_free()

		# spawn new items
		prev_road.position.z -= road_size * road_blocks
		var r_pos

		if rng.randi_range(0, 2):
			var new_pickup = pickup.instantiate()
			r_pos = random_position(prev_road)
			new_pickup.position.z = r_pos[0]
			new_pickup.position.x = r_pos[1]
			new_pickup.position.y = 0.7
			pickups.add_child(new_pickup)
		
		for i in rng.randi_range(int(blocks_found)-1, int(blocks_found)+1):
			var new_obstacle = obstacle.instantiate()
			r_pos = random_position(prev_road)
			new_obstacle.position.z = r_pos[0]
			new_obstacle.position.x = r_pos[1]
			new_obstacle.position.y = 0.7
			obstacles.add_child(new_obstacle)


func random_position(prev_road):
	var r_pos = []

	while true:
		var temp = []
		var positions = [-1.5, -0.5, 0.5, 1.5]
		temp.append(prev_road.position.z + (positions.pick_random() * floor(road_size / z_lanes)))
		temp.append(rng.randi_range(-1, 1) * x_spacing)
		if temp not in seen_pos:
			r_pos = temp
			break

	seen_pos.append(r_pos)
	return r_pos
