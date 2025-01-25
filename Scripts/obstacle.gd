extends Node3D

@export var material : Material
@onready var mesh: MeshInstance3D = $Area3D/MeshInstance3D

func _ready() -> void:
	mesh.set_surface_override_material(0, material)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.speed = 1.0
		mesh.visible = false
