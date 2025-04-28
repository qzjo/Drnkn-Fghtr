extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#https://www.youtube.com/watch?v=lDMInA-Bb2k

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	$Volume/Label.text = "Volume: " + str(linear_to_db(value))


func _on_check_button_toggled(toggled_on: bool) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	if toggled_on:
		AudioServer.set_bus_mute(bus_idx, true) # or false
	else:
		AudioServer.set_bus_mute(bus_idx, false) # or false
