extends Node2D

@onready var character: Player = $Character
@onready var door: Area2D = $Door
@onready var next_level: PackedScene
var player_in: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character.find_child("UI").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
