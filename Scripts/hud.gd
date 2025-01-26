extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var player: CharacterBody3D = $"../../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = player.power
