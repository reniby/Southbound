extends Node3D

@onready var mesh: Node3D = $Area3D/Mesh

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.power += 10
