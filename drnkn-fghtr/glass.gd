extends RigidBody2D

@onready var character: Player = $"../Character"
var inArea = false
@onready var sprite_2d: Sprite2D = $"../Character/Sprite2D"
var follow: Sprite2D

func _ready() -> void:
	follow = sprite_2d

func _on_area_2d_body_entered(body: Node2D) -> void:
	inArea = true # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	inArea = false # Replace with function body.


func _process(delta: float) -> void:
	if inArea and Input.is_action_just_pressed("pick_up"):
		print("Added " + name )
		queue_free()
