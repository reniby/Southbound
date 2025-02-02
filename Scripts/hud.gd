extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var player = $"../../Player"
@onready var jazz: AudioStreamPlayer3D = $"../../Player/Jazz"
@onready var score_label: RichTextLabel = $ScoreLabel
@onready var mult_label: RichTextLabel = $MultLabel

const LOW_GEAR = 5.0
const MID_GEAR = 15.0
const HIGH_GEAR = 25.0

func _ready():
	change_music(jazz)
	score_label.text = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	progress_bar.value = player.power
	
	score_label.text = str(int(player.score))
	if player.mult > 1.0:
		mult_label.text = "x" + str(player.mult)
	else:
		mult_label.text = ""
		

func change_music(genre):
	genre.play()


func _on_low_pressed() -> void:
	player.speed = LOW_GEAR

func _on_med_pressed() -> void:
	player.speed = MID_GEAR

func _on_high_pressed() -> void:
	player.speed = HIGH_GEAR




func _on_off_pressed() -> void:
	player.set_lights(0)

func _on_regular_pressed() -> void:
	player.set_lights(1)

func _on_brights_pressed() -> void:
	player.set_lights(2)
