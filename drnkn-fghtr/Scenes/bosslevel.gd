extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var character: Player = $Character
@onready var door: Area2D = $Door
var in_door_area = false
var paused = false
@onready var pause_screen: Control = $Pause/PauseScreen



func _ready() -> void:
	get_tree().paused = false
	character.find_child("UI").visible = true
	audio_stream_player.play()



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseScreen()
		
		
func pauseScreen():
	if paused:
		pause_screen.hide()
		Engine.time_scale = 1
	else:
		pause_screen.show()
		Engine.time_scale = 0
		
	paused = !paused
	
	
