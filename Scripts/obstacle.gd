extends Node3D

@onready var mesh: Node3D = $"Area3D/bm-blockade"
@export var obstacle_type : int
@onready var fx: AudioStreamPlayer3D = $Area3D/AudioStreamPlayer3D

var speed_changes = [5.0, 5.0]

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.power -= 10
		body.speed = speed_changes[obstacle_type]
		mesh.visible = false
		fx.play()
