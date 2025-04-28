extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var character: Player = $Character
@onready var door: Area2D = $Door
var in_door_area = false
var paused = false


func _ready() -> void:
	get_tree().paused = false
	character.find_child("UI").visible = true
	audio_stream_player.play()



func _process(delta: float) -> void:
	pass
