extends Sprite2D

@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D

@export var stats : Item
@export var skill : Skill

@onready var character: Player = $"../Character"

var inarea: Player = null

func _ready() -> void:
	if stats != null:
		texture = stats.icon

func _process(delta: float) -> void:
	if inarea and Input.is_action_just_pressed("pickup"):
		pickup_item()

func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		inarea = body

func _on_player_exited(body: Node2D) -> void:
	if body == inarea:
		inarea = null

func pickup_item() -> void:
	var body = character
	if inarea:
		print("Picked up!")
		call_deferred("reparent", body, find_child("Weapons"))
		queue_free()
		#position = body.position
		body.add_item(stats,skill)
		collision.call_deferred("set_disabled", true)
		
