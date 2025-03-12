extends CharacterBody2D

@onready var target = $"../Character"

const speed = 300.0


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	
	
	var direction = (target.position - position).normalized()
	velocity = direction * speed
	

	move_and_slide()
	
