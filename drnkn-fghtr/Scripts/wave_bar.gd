extends ProgressBar

@onready var mob: = get_tree().current_scene.find_child("Mob")
@onready var label: Label = $Label
@onready var total = get_tree().get_nodes_in_group("enemies").size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(total)
	max_value = total
	value = total
	label.text = "enemies left:" + str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "enemies left: " + str(value)
	 ## CURRENTLY BROKEN SAYS THERES 2 MOBS FOR LEVEL 2 BUT THERES ONLY ONE AND IT DOESNT GO DOWN WHEN MOB IN LEVEL 2 DIES
	## MAYBE TRY CHANGING THE WAVE BAR WHEN LEVEL 2 IT LOADED??? MAKE IT A FUNCTION ???


func _on_mobdied() -> void:
	value -= 1
