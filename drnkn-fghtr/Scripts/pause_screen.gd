extends Control


@onready var pause_screen: Control = $"."

@onready var game = $"../../"

func _on_resume_pressed() -> void:
	pause_screen.hide()
	Engine.time_scale = 1


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		game.audio_stream_player.volume_db = -80  # Effectively mute the audio
	else:
		game.audio_stream_player.volume_db = 0  # Restore normal volume
