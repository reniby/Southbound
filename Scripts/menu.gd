extends Node3D

@onready var start: Button = $Start
@onready var title: Label = $Title
@onready var tutorial: Label = $Tutorial
@onready var begin: Button = $Begin
@onready var scores: Label = $Scores

func _ready():
	if State.started:
		fill_board()
		tutorial.visible = false
		scores.visible = true
		begin.visible = true
		begin.disabled = false
		begin.text = "RETRY"
	else:
		start.disabled = false
		title.visible = true
		start.visible = true

func descending(a,b):
	if a > b: return true
	return false

func fill_board():
	var suffix = ["st", "nd", "rd", "th", "th"]
	State.high_scores.sort_custom(descending)
	var curr = ""
	for i in range(5):
		var iScore = snapped(State.high_scores[i], 0.01) if len(State.high_scores) > i else ""
		curr += str(i+1) + suffix[i] + ": " + str(iScore) + "\n"
	scores.text = curr

func _on_start_pressed() -> void:
	start.disabled = true
	title.visible = false
	start.visible = false
	
	tutorial.visible = true
	begin.visible = true
	begin.disabled = false

func _on_begin_pressed() -> void:
	State.started = true
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
