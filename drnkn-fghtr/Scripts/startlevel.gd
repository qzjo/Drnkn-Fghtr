extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var character: Player = $Character
@onready var door: Area2D = $Door
var in_door_area = false



func _ready() -> void:
	get_tree().paused = false
	character.find_child("UI").visible = false
	audio_stream_player.play()



func _process(delta: float) -> void:
	if in_door_area and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/game.tscn")




func _on_door_area_entered(area: Area2D) -> void:
	in_door_area = true


func _on_door_area_exited(area: Area2D) -> void:
	in_door_area = false
