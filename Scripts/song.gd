extends Node3D

@onready var song: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	song.play()
