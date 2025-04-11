extends Button
class_name Slot

## https://www.youtube.com/watch?v=DaZsCPuDJ5c
@onready var player = get_tree().current_scene.find_child("Character")
@onready var AURA = preload("res://Resources/Skills/Aura.tres")
@onready var STAB = preload("res://Resources/Skills/Stab.tres")
@onready var test = load("res://Skill.gd")
@onready var mobs: = get_tree().get_nodes_in_group("enemies")



@export var stats: Item = null:
	set(value):
		stats = value
		
		if value != null:
			icon = value.icon
		else:
			icon = null
			
@export var skill: Skill = null


func _ready() -> void:
	
	set_process_input(false)
	
	
func remove_item():
	var weaponHolder = player.find_child("Weapons")
	var itm = weaponHolder.find_child("*AbstractItem*", true)
	if itm:
		itm.queue_free()



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		use_item()

func use_item():
	
	if stats == null:
		return	
	print("Used")
	

	match skill: ## ADD ANY NEW THINGS
		AURA:
			
			AURA.uses -= 1
			if AURA.uses <= 0:
				remove_item()
				stats = null
				skill = null
			player.SPEED += 100.0
			print(player.SPEED)
			print("JJJ")
		STAB:
			STAB.uses -= 1
			if STAB.uses <= 0:
				remove_item()
				stats = null
			if mobs.size() >= 0:
				for mob in mobs:
					mob.dmg = 100
			player.health += 50.0
			print("LLL")
			


func _on_pressed() -> void:
	use_item()
	get_parent().current_index = get_index()
	player.find_child("Weapons")._on_index(get_index())
