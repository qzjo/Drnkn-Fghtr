extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var character: Player = $Character
@onready var door: Area2D = $Door
var in_door_area = false

@onready var animation_player: AnimationPlayer = $LoreIntro/AnimationPlayer
@onready var label: Label = $LoreIntro/back/Label
@onready var lore_intro: CanvasLayer = $LoreIntro

func _ready() -> void:
	animation_player.play("textappear")
	animation_player.play("textfade")
	await animation_player.animation_finished
	label.text = "imimimimik"
	animation_player.play("textappear")
	await animation_player.animation_finished
	animation_player.play("fadeOut")
	character.find_child("UI").visible = false

	
	get_tree().paused = false
	audio_stream_player.play()



func _process(delta: float) -> void:
	if in_door_area and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/game.tscn")




func _on_door_area_entered(area: Area2D) -> void:
	in_door_area = true


func _on_door_area_exited(area: Area2D) -> void:
	in_door_area = false


func _on_button_pressed() -> void:
	lore_intro.visible = false # Replace with function body.
