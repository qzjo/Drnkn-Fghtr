extends Node2D

@onready var character: Player = $"../Character"
@onready var slot: Button = $"../Character/UI/Hotbar/slot"

var in_door_area = false
@onready var transition: ColorRect = $"../BLCKTRANS/TRANSITION"
@onready var ap: AnimationPlayer = $"../BLCKTRANS/TRANSITION/AnimationPlayer"
@onready var camera_2d: Camera2D = $Camera2D
var back_area = false
@onready var walk_barrier: CollisionShape2D = $"../LeftWall/WalkBARRIER"
@onready var spawnpoint: Sprite2D = $spawnpoint
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure collision shapes are enabled at game start
	print("lvl2")
#	cboss.disabled = true

@onready var level_detector: Area2D = $LevelDetector
@onready var collision_shape_2d: CollisionShape2D = $LevelDetector/CollisionShape2D
@onready var collision_shape: CollisionShape2D = $"../Detector2/CollisionShape2D"
@onready var wave_bar: ProgressBar = $"../Character/UI/WaveBar" ## FOR MOBS
@onready var mob_healthbar: ProgressBar = $mobHealthbar

@onready var cboss: CollisionShape2D = $DoorImage2/Area2D/CollisionShape2D
@onready var label: Label = $mobHealthbar/Label
var creegann = preload("res://Scenes/creegan.tscn").instantiate()
@onready var abstract_item_6: Sprite2D = $"../AbstractItem6"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		wave_bar.value = 0




func spawnmob():
#	var newmobs = preload("res://Scenes/mob.tscn").instantiate()
#	newmobs.add_to_group("enemies")
#	get_tree().current_scene.add_child(newmobs)
#w	newmobs.global_position = spawnpoint.global_position

	creegann.add_to_group("enemies")
	get_tree().current_scene.add_child(creegann)
	creegann.global_position = spawnpoint.global_position
	creegann.health = 325

## FIX HEALTHBAR
	creegann.speed = 75
	character.damg = 30


func _on_level_detector_body_entered(body: CharacterBody2D) -> void:
	in_door_area = true
	print("Level2")
	character.z_index = 999
	#cboss.disabled = false


	spawnmob()

	if body == character:
		character.z_index = 999
		character.top_level = true
		transition.visible = true
		ap.play("fadeIN")
		character.SPEED = 0
		await ap.animation_finished
		wave_bar.value = get_tree().get_nodes_in_group("enemies").size()
		wave_bar.max_value = get_tree().get_nodes_in_group("enemies").size()
		ap.play("fadeOUT")
		slot.update_mob_damage()
		camera_2d.enabled = true
		await ap.animation_finished
		character.SPEED = 300
		transition.visible = false
		collision_shape_2d.disabled = true
		walk_barrier.disabled = false
		
		


func _on_level_detector_body_exited(body: Node2D) -> void:
	character.z_index = 999
	





func _on_transition_detector_body_entered(body: Node2D) -> void:
	back_area = true # Replace with function body.
	print("entered")
	character.z_index = 999



func _on_transition_detector_body_exited(body: Node2D) -> void:
	back_area = false # Replace with function body.
	character.z_index = -91
