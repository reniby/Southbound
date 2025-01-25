extends Node3D

@onready var mesh: Node3D = $Area3D/Mesh
@export var obstacle_type : int

var speed_changes = [1.0, 5.0]

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.speed = speed_changes[obstacle_type]
		mesh.visible = false
