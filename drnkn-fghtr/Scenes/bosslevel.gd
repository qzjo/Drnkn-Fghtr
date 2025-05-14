extends Node2D

var in_door_area = false
var paused = false
@onready var pause_screen: Control = $Pause/PauseScreen
@onready var character: Player = $"../Character"


var bossdoor = false


func _ready() -> void:
	get_tree().paused = false
	character.find_child("UI").visible = true



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseScreen()
		
	if bossdoor and Input.is_action_pressed("ui_accept"):
		print("Bossdoor")
		
func pauseScreen():
	if paused:
		pause_screen.hide()
		Engine.time_scale = 1
	else:
		pause_screen.show()
		Engine.time_scale = 0
		
	paused = !paused
	

	


func _on_bossdoor_body_entered(body: Node2D) -> void:
	bossdoor = true # Replace with function body.


func _on_bossdoor_body_exited(body: Node2D) -> void:
	bossdoor = false # Replace with function body.
