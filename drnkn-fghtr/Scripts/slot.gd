extends Button
class_name Slot

## MAKE THE PLAYER HAVE THE PICKAXE IN THERI INVENTORY EITHER MAKE THEM PRESS A BUTTON USING CODE TO PICK IT UP OR MAKE IT SELECTED AND IN THEIR INVENTORY
## FIX THE SCROLL SO IT HEALS

## https://www.youtube.com/watch?v=DaZsCPuDJ5c
@onready var player = get_tree().current_scene.find_child("Character")
@onready var AURA = preload("res://Resources/Skills/Aura.tres")
@onready var STAB = preload("res://Resources/Skills/Stab.tres")
@onready var test = load("res://Skill.gd")
@onready var mobs: = get_tree().get_nodes_in_group("enemies")
@onready var Scroll = preload("res://Resources/Skills/scroll.tres")

@onready var particle: ColorRect = $Character/Particle

@export var stats: Item = null:
	set(value):
		# Make a duplicate of the resource to ensure unique durability
		if value != null:
			stats = value.duplicate()
			icon = stats.icon
		else:
			stats = null
			icon = null
			
@export var skill: Skill = null


func _ready() -> void:
	set_process_input(false)
	set_process(false)  # Start with process disabled
	# Connect to the hotbar's index signal
	get_parent().index.connect(_on_hotbar_index)
	
	# Check if this slot is initially selected
	if get_parent().current_index == get_index():
		update_mob_damage()

# Function to check if this slot is selected and update damage
func _on_hotbar_index(index: int) -> void:
	if index == get_index():
		update_mob_damage()

# Function to update mob damage based on the current item
func update_mob_damage() -> void:
	if stats != null:
		if "knife" in stats.name.to_lower(): ## CHANGE KNIFE TO WHATEVER ITEM IS IN THE ABSTRACTITEM YOU WANT TO CHANGE BUFFS OF
			# Set damage value for all mobs in the scene
			for mob in get_tree().get_nodes_in_group("enemies"):
				mob.dmg = 25
			print("Knife selected! Mob damage set to: 50")
		elif "pickaxe" in stats.name.to_lower():
			for mob in get_tree().get_nodes_in_group("enemies"):
				mob.dmg = 15
		elif "axe" in stats.name.to_lower():
			for mob in get_tree().get_nodes_in_group("enemies"):
				mob.dmg = 45
	else:
		# Reset damage to default value for all mobs
		for mob in get_tree().get_nodes_in_group("enemies"):
			mob.dmg = 5
		print("Non-knife item selected! Mob damage reset to: 5")

func remove_item():
	var weaponHolder = player.find_child("Weapons")
	var itm = weaponHolder.find_child("*AbstractItem*", true)
	if itm:
		itm.queue_free()
		return
	
	# If no AbstractItem found, check for any Sprite2D that might be glitched
	for child in weaponHolder.get_children():
		if child is Sprite2D:
			child.queue_free()

func _process(delta: float) -> void:

	# Continuously check if punch is pressed when STAB skill is active
	if skill == STAB and stats and stats.durability > 0:
		if Input.is_action_pressed("punch"):
			player.apply_skill_enhancement("STAB")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		use_item()
		
	# Check for backspace to drop item when this slot is selected
	if event.is_action_pressed("ui_text_backspace") and get_parent().current_index == get_index() and stats != null:
		drop_item()
		
	# Enable process monitoring when relevant skill is active
	if skill == STAB and stats and stats.durability > 0:
		set_process(true)
	else:
		set_process(false)

"""CHANGE DURABILITY IN INSPECTOR NOT IN THE CODE!"""

func use_item():
	
	if stats == null:
		return	
	print("Used")
	
	# Reduce durability when item is used
	if stats.durability > 0:
		stats.durability -= 1
		print(str(stats.durability))
		
		# Check if item is broken
		if stats.durability <= 0:
			remove_item()
			stats = null
			skill = null
			set_process(false)  # Make sure processing stops if item breaks
			return

	match skill: ## ADD ANY NEW THINGS
		Scroll:
			player.health += 10
			
			var effect = player.find_child("Particle")
			effect.visible = true
			await get_tree().create_timer(1).timeout
			effect.visible = false


# Function to drop the current item
func drop_item():
	if stats == null:
		return
	print("Item dropped: " + stats.name)
	
	# Create and setup the dropped item
	var dropped_item = preload("res://Scenes/abstract_item.tscn").instantiate()
	dropped_item.stats = stats.duplicate()
	dropped_item.skill = skill
	dropped_item.custom_durability = stats.durability
	
	# Add to scene at player's position
	get_tree().current_scene.add_child(dropped_item)
	dropped_item.global_position = player.global_position
	
	# Clear inventory slot
	AudioController.play_drop()
	remove_item()
	stats = null
	skill = null
	set_process(false)

func _on_pressed() -> void:
	use_item()
	# Clear any existing skill enhancement when changing slots
	player.clear_skill_enhancement()
	get_parent().current_index = get_index()
	player.find_child("Weapons")._on_index(get_index())
	
	# No need to update mob damage here as it will be handled by the index signal

# Function to properly set an item with a custom durability
func set_item(item: Item, custom_durability: int = -1, item_skill: Skill = null) -> void:
	stats = item # This calls the setter which duplicates the item
	
	if custom_durability > 0:
		stats.durability = custom_durability
		
	if item_skill:
		skill = item_skill
		
	# Update mob damage based on this item
	if get_parent().current_index == get_index():
		update_mob_damage()
