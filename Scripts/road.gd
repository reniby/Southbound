extends Node3D

@onready var road_1: Node3D = $"../road1"
@onready var road_2: Node3D = $"../road2"

func _on_area_3d_body_entered(body: Node3D) -> void:
	var curr_road = road_2 if self.is_in_group("Road1") else road_1
	
	curr_road.position.z -= 114
	for area in curr_road.get_node("Area3D").get_overlapping_areas():
		area.position.z -= 114
		area.get_node("Mesh").visible = true
