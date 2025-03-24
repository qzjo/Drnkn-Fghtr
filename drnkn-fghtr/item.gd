extends Resource
class_name Item

@export var display_name := ""
@export var texture: Texture2D = null
@export var sound_on_pickup: AudioStream = null

func use(player: Player) -> void:
	pass
