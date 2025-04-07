extends Panel

@onready var player = get_tree().current_scene.find_child("Character")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")



func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://start_screen.tscn")

func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_character_plrdied() -> void:
	player.visible = false
	visible = true # Replace with function body.
