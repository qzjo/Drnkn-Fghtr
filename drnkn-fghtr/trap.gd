extends CharacterBody2D


var bullet_path = preload("res://bullet.tscn")


func _physics_process(delta: float) -> void:
	pass

func fire():
	var bullet = bullet_path.instantiate()
	bullet.dir = $Node2D.global_rotation
	bullet.pos = $Node2D.global_position
	bullet.rota = global_rotation
	get_parent().add_child(bullet)
	AudioController.play_arrow()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		fire()
