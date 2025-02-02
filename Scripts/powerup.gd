extends Node3D

@onready var mesh: Node3D = $Area3D/bm_pickup_gasoline
@onready var fx: AudioStreamPlayer3D = $Area3D/AudioStreamPlayer3D

func _process(delta):
	rotation.y -= 2 * delta

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.power += 10
		fx.play()
		visible = false
