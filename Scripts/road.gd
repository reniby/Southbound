extends Node3D

@onready var road_1: Node3D = $"../road1"
@onready var road_2: Node3D = $"../road2"
@onready var road_3: Node3D = $"../road3"

@onready var player: VehicleBody3D = $"../../Player"


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent_node_3d().name == "Player":
		print(self.get_groups())
		var prev_road
		if self.is_in_group("Road1"): prev_road = road_2
		elif self.is_in_group("Road2"): prev_road = road_3
		else: prev_road = road_1
		print("prev: ", prev_road)
		
	
		prev_road.position.z -= 57 * 3
		for items in prev_road.get_node("Area3D").get_overlapping_areas():
			if items.get_parent_node_3d().name != "Player":
				items.position.z -= 57 * 3
				items.get_node("Mesh").visible = true
