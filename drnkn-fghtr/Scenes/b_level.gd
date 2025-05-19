extends Node2D

@onready var door: Sprite2D = $Door
@onready var vignette_3: CanvasLayer = $Vignette3
@onready var camera_2d: Camera2D = $"../Level2/Camera2D"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Vignette3/ColorRect/Label
@onready var wave_bar: ProgressBar = $"../Character/UI/WaveBar"
@onready var spawnpoint: Sprite2D = $spawnpoint
@onready var spawnpoint_2: Sprite2D = $spawnpoint2
@onready var spawnpoint_3: Sprite2D = $spawnpoint3
@onready var bspawnpoint: Sprite2D = $bspawnpoint

var follow = false
var bossdoor = false
@onready var transition: ColorRect = $"../BLCKTRANS/TRANSITION"
@onready var ap: AnimationPlayer = $"../BLCKTRANS/TRANSITION/AnimationPlayer"
@onready var character: Player = $"../Character"
@onready var slot: Button = $"../Character/UI/Hotbar/slot"
@onready var charactercam: Camera2D = $"../Character/charactercam"

@onready var abstract_item_6: Sprite2D = $"../AbstractItem6"

@onready var axe = preload("res://Resources/Items/axe.tres")
@onready var STAB = preload("res://Resources/Skills/Stab.tres")
@onready var custom_durability: int = 12
@onready var BOSS = preload("res://Scenes/peery.tscn").instantiate()

@onready var win_checker: CanvasLayer = $"../Win Checker"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	
	if bossdoor and Input.is_action_just_pressed("ui_accept"):
		AudioController.play_door()
		print("Boss!")
		transition.visible = true
		ap.play("fadeIN")
		character.SPEED = 0
		await ap.animation_finished
		character.global_position = door.global_position
		wave_bar.visible = false
		vignette_3.visible = true
		vignette_3.follow_viewport_enabled = true
		camera_2d.position = Vector2(-439,319)
		ap.play("fadeOUT")
		slot.update_mob_damage()
		await ap.animation_finished
		character.SPEED = 0
		transition.visible = false
		camera_2d.enabled = true
		animation_player.play("labelfade")
		await animation_player.animation_finished
		label.visible = false
		camani()
		
		spawnmob()
	


	
	
func spawnmob():
	var newmobs = preload("res://Scenes/mob.tscn").instantiate()
	newmobs.add_to_group("enemies")
	get_tree().current_scene.add_child(newmobs)
	newmobs.global_position = spawnpoint.global_position


		
func camani():
	var tween1 := get_tree().create_tween()

	tween1.tween_property(camera_2d,"position",Vector2(-1773,319),2.2)
	


	await tween1.finished
	AudioController.play_boss()
	BOSS.add_to_group("enemies")
	get_tree().current_scene.add_child(BOSS)
	BOSS.global_position = bspawnpoint.global_position
	BOSS.health = 750
	BOSS.speed = 80
	character.damg = 50

	await get_tree().create_timer(1).timeout
	
	var tween2 := get_tree().create_tween()
	tween2.tween_property(camera_2d,"position",Vector2(-439,319),1.5)
	
	await tween2.finished
	await get_tree().create_timer(.5).timeout
	
	character.SPEED = 300
	camera_2d.enabled = false
	
	charactercam.enabled = true
	
	
func _on_b_door_body_entered(body: Node2D) -> void:
	if body is Player:
		bossdoor = true # Replace with function body.
		print("Entered")


func _on_b_door_body_exited(body: Node2D) -> void:
	if body is Player:
		bossdoor = false # Replace with function body.
		print("exited")
