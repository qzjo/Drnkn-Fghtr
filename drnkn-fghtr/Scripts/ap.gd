extends CanvasLayer

@onready var character: Player = $"../Character"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_skip_1_button_pressed() -> void:
	for Mob in get_tree().get_nodes_in_group("enemies"):
		Mob.queue_free() # Replace with function body.


func _on_hp_button_pressed() -> void:
	character.health = 99999999 # Replace with function body.
