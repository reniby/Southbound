extends Node3D

@onready var road_1: Node3D = $"../road1"
@onready var road_2: Node3D = $"../road2"
@onready var road_3: Node3D = $"../road3"
@onready var road_4: Node3D = $"../road4"
@onready var pickups: Node = $"../../Pickups"

@export var pickup: PackedScene
@export var obstacle: PackedScene

@onready var player: VehicleBody3D = $"../../Player"
var road_blocks = 4
var road_size = 57

var blocks_found = 0

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d().name == "Player":
		blocks_found += 1
		var prev_road

		var road_order = ["Road1","Road2","Road3","Road4"]
		var roads = [road_1, road_2, road_3, road_4]
		for r in len(road_order):
			if self.is_in_group(road_order[r]):
				prev_road = roads[(r+2)%4]

		prev_road.position.z -= road_size * road_blocks
		for i in blocks_found:
			var new_pickup = pickup.instantiate()
			new_pickup.position.z = prev_road.position.z
			new_pickup.position.y = 0.7
			pickups.add_child(new_pickup)
