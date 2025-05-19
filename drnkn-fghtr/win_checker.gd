extends Node2D




# Called every frame. 'delta' is the elapsed time since the previous frame.

	
func checkwin():
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		print("")
