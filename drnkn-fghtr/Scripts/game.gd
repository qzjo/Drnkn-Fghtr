extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pause_screen: Control = $Pause/PauseScreen
@onready var settings: CanvasLayer = $Pause/PauseScreen/Settings

var paused = false
@onready var character: Player = $Character
@onready var door: Area2D = $Door
var in_door_area = false
var back_area = true
@onready var door_image: Sprite2D = $DoorImage
@onready var walk_barrier: CollisionShape2D = $LeftWall/WalkBARRIER

@onready var collision_shape_2d: CollisionShape2D = $LeftWall/Detector/CollisionShape2D
@onready var ap: AnimationPlayer = $BLCKTRANS/TRANSITION/AnimationPlayer
@onready var camera_2d: Camera2D = $"Level 2/Camera2D"

@onready var transition: ColorRect = $"../BLCKTRANS/TRANSITION"
@onready var collision_shape_2dd: CollisionShape2D = $Detector2/CollisionShape2D
@onready var collision_shape: CollisionShape2D = $"Level 2/TransitionDetector/CollisionShape2D"
@onready var ontopwall: CollisionShape2D = $LeftWall/Detector/CollisionShape2D
@onready var quest_guy: Sprite2D = $QuestGuy


@onready var PICKAXE = preload("res://Resources/Items/Pickaxe.tres")
@onready var STAB = preload("res://Resources/Skills/Stab.tres")
@onready var custom_durability: int = 99999
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	character.find_child("UI").visible = true
	audio_stream_player.play()
	#questcollision.disabled = true
	character.add_item(PICKAXE, STAB, custom_durability)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseScreen()
		
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		quest_guy.visible = true
		#questcollision.disabled = false
	
	if in_door_area and Input.is_action_just_pressed("ui_accept") and get_tree().get_nodes_in_group("enemies").size() == 0: ## DOOR
		if has_node("Door") == true:
			door_image.visible = false
		elif has_node("Door") == false:
			print(" ")
			
		ontopwall.disabled = false
		walk_barrier.disabled = true
		collision_shape_2d.disabled = false
		character.z_index = -91
		
	if in_door_area:
		character.z_index = -91

	
	if back_area: ##
		character.z_index = 999
	else:
		character.z_index = -91

func pauseScreen():
	if paused:
		pause_screen.hide()
		settings.visible = false
		Engine.time_scale = 1
	else:
		pause_screen.show()
		Engine.time_scale = 0
		
	paused = !paused
	
## NEXT LEVEL HANDLER

func _on_door_body_entered(body: Node2D) -> void:
	in_door_area = true
	character.z_index = -91

func _on_door_body_exited(body: Node2D) -> void:
	in_door_area = false

func _on_detector_body_entered(body: Node2D) -> void:
	back_area = true

func _on_detector_body_exited(body: Node2D) -> void:
	back_area = false

## Transition Handler

func _on_transition_detector_body_entered(body: Node2D) -> void:
	back_area = true # Replace with function body.


func _on_transition_detector_body_exited(body: Node2D) -> void:
	back_area = false # Replace with function body.

@onready var aPanel: CanvasLayer = $AP

func _on_apbutton_pressed() -> void:
	if aPanel.visible == false:
		aPanel.visible = true
	else:
		aPanel.visible = false
