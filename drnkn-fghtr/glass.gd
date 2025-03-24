extends RigidBody2D

@onready var character: Player = $"../Character"
var inArea = false
@onready var sprite_2d: Sprite2D = $"../Character/Sprite2D"
@onready var lb1: Label = $"../Hotbar/Background/Organizer/Box1/Label"
@onready var lb2: Label = $"../Hotbar/Background/Organizer/Box2/Label"
@onready var lb3: Label = $"../Hotbar/Background/Organizer/Box3/Label"


func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	inArea = true # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	inArea = false # Replace with function body.


func _process(delta: float) -> void:
	if inArea and Input.is_action_just_pressed("pick_up"):
		print("Added " + name )
		queue_free()

		if lb1.text == "1":
			lb1.text = sprite_2d.get_parent().name
		elif lb1.text != sprite_2d.get_parent().name:
			print("worked")
