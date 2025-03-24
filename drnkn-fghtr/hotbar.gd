class_name hb extends Control

@export var slots = [null, null, null]
@onready var glass: Pickup = $"../Glass"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	selected(1)
	# LLOLOLOLOLOOL


func selected(slot_index):
	if Input.is_key_pressed(KEY_1):
		slot_index = slots[0]
		print(slot_index)
		$Background/Organizer/Box1/Label.text = slots[0]
	elif Input.is_key_pressed(KEY_2):
		slot_index = slots[1]
		print(slot_index)
		$Background/Organizer/Box2/Label.text = slots[1] # FIX THIS NULL CANT BE THE SLOT TEXT
	elif Input.is_key_pressed(KEY_3):
		slot_index = slots[2]
		print(slot_index)
		$Background/Organizer/Box3/Label.text = slots[2]
	
	


func _on_glass_selectedd() -> void:
	
	if slots[0] == null: # cehcks if slot 0 hsa nothing
		slots[0] = glass.itemname # chanegs text to glass name 
	elif slots[0] != null: # checks if slot 0 has something
		slots[1] = glass.itemname # then changes slot 1 text
	elif slots[1] == null: # checks if slot 1 has snothing
		slots[1] = glass.itemname #cchanges slot 1 text
	elif slots[1] != null: # cehcks if slot 1 does has somwething
		slots[2] = glass.itemname # changes slot 3 to costhing
	elif slots[2] == null: #checkcs if slot 3 is exmpy
		slots[2] = glass.itemname
	elif slots[2] != null:
		print("Full")
	
	#slots[0] = glass.itemname
	
	 # Replace with function body.
