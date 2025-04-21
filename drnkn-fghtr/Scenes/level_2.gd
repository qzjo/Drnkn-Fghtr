extends Node2D

@onready var character: Player = $"../Character"

var in_door_area = false
@onready var transition: ColorRect = $"../BLCKTRANS/TRANSITION"
@onready var ap: AnimationPlayer = $"../BLCKTRANS/TRANSITION/AnimationPlayer"
@onready var camera_2d: Camera2D = $Camera2D
var back_area = false
@onready var walk_barrier: CollisionShape2D = $"../LeftWall/WalkBARRIER"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure collision shapes are enabled at game start
	pass

@onready var level_detector: Area2D = $LevelDetector
@onready var collision_shape_2d: CollisionShape2D = $LevelDetector/CollisionShape2D
@onready var collision_shape: CollisionShape2D = $"../Detector2/CollisionShape2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	#if back_area: ##
	#	character.z_index = 999
	#	print("!!")
	#else:
	#	character.z_index = -91

func _on_level_detector_body_entered(body: CharacterBody2D) -> void:
	in_door_area = true
	print("Level2")
	# Disable the other detector so it won't trigger when character enters that area

		
	transition.visible = true
	ap.play("fadeIN")
	character.SPEED = 0
	await ap.animation_finished
	ap.play("fadeOUT")
	camera_2d.enabled = true
	await ap.animation_finished
	character.SPEED = 300
	transition.visible = false
	collision_shape_2d.disabled = true
	walk_barrier.disabled = false


func _on_level_detector_body_exited(body: Node2D) -> void:
	pass


func _on_transition_detector_body_entered(body: Node2D) -> void:
	back_area = true # Replace with function body.
	print("entered")
	character.z_index = 999



func _on_transition_detector_body_exited(body: Node2D) -> void:
	back_area = false # Replace with function body.
	character.z_index = -91
