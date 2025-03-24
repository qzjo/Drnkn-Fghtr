extends Item
class_name beer

@export var healing_amount := 100

func use(player: Player) -> void:
	player.health += healing_amount
