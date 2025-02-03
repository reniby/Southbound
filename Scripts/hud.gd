extends Node2D

@onready var player = $"../../Player"
@onready var jazz: AudioStreamPlayer3D = $"../../Player/Jazz"
@onready var score_label: RichTextLabel = $ScoreLabel
@onready var mult_label: RichTextLabel = $MultLabel

@onready var low: Button = $Gears/Low
@onready var med: Button = $Gears/Med
@onready var high: Button = $Gears/High

@onready var off: Button = $Gears2/Off
@onready var regular: Button = $Gears2/Regular
@onready var brights: Button = $Gears2/Brights

const LOW_GEAR = 15.0
const MID_GEAR = 22.5
const HIGH_GEAR = 30.0

func _ready():
	change_music(jazz)
	score_label.text = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.power <= 0:
		State.high_scores.append(player.score)
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
	score_label.text = str(int(player.score))
	if player.mult > 1.0:
		mult_label.text = "x" + str(player.mult)
	else:
		mult_label.text = ""

	if player.speed == LOW_GEAR:
		set_colors(low, Color.WHITE)
		set_colors(med, Color.DIM_GRAY)
		set_colors(high, Color.DIM_GRAY)
	elif player.speed == MID_GEAR:
		set_colors(low, Color.DIM_GRAY)
		set_colors(med, Color.WHITE)
		set_colors(high, Color.DIM_GRAY)
	else:
		set_colors(low, Color.DIM_GRAY)
		set_colors(med, Color.DIM_GRAY)
		set_colors(high, Color.WHITE)
	
	if player.light_power == 0:
		set_colors(off, Color.WHITE)
		set_colors(regular, Color.DIM_GRAY)
		set_colors(brights, Color.DIM_GRAY)
	elif player.light_power == 1:
		set_colors(off, Color.DIM_GRAY)
		set_colors(regular, Color.WHITE)
		set_colors(brights, Color.DIM_GRAY)
	else:
		set_colors(off, Color.DIM_GRAY)
		set_colors(regular, Color.DIM_GRAY)
		set_colors(brights, Color.WHITE)


func set_colors(button, color):
	button.add_theme_color_override("font_color", color)
	button.add_theme_color_override("font_pressed_color", color)
	button.add_theme_color_override("font_hover_color", color)
	button.add_theme_color_override("font_focus_color", color)


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
