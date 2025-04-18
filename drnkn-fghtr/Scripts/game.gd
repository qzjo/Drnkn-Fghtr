extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pause_screen: Control = $PauseScreen
var paused = false
@onready var character: Player = $Character
@onready var door: Area2D = $Door
var in_door_area = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	character.find_child("UI").visible = true
	audio_stream_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseScreen()
	
	if in_door_area and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")


func pauseScreen():
	if paused:
		pause_screen.hide()
		Engine.time_scale = 1
	else:
		pause_screen.show()
		Engine.time_scale = 0
		
	paused = !paused
	
