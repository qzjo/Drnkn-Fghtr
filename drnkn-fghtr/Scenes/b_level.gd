extends Node2D

var bossdoor = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bossdoor and Input.is_action_just_pressed("ui_accept"):
		print("Boss!")

func _on_b_door_body_entered(body: Node2D) -> void:
	if body is Player:
		bossdoor = true # Replace with function body.
		print("Entered")


func _on_b_door_body_exited(body: Node2D) -> void:
	if body is Player:
		bossdoor = false # Replace with function body.
		print("exited")
