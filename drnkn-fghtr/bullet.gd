extends CharacterBody2D

var pos: Vector2
var rota:float
var dir : float
var speed = 2000
var damage = 5
@onready var bulletarea: Area2D = $Area2D

func _ready():
	global_position = pos
	global_rotation = rota
	bulletarea.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			body.take_damage(damage)
				
				
			)

func _physics_process(delta: float) -> void:
	velocity=Vector2(speed, 0).rotated(dir)
	move_and_slide()
