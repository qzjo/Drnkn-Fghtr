extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var settings: CanvasLayer = $Settings

@onready var fade: AnimationPlayer = $Transition/FADE
@onready var transition: CanvasLayer = $Transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	audio_stream_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().paused = false
	transition.visible = true
	fade.play("fadein")
	await fade.animation_finished
	get_tree().change_scene_to_file("res://Scenes/startlevel.tscn")
	



func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	settings.visible = true # Replace with function body.
