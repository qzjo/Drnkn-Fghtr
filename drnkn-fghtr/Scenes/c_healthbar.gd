extends ProgressBar

@onready var healthbar: ProgressBar = $"."


func _ready() -> void:
	max_value = 250

func _process(delta: float) -> void:
	
	var style: StyleBoxFlat = healthbar.get_theme_stylebox("fill")
	
	value = get_parent().health
	
	


func _on_mob_mobhit() -> void:
	$AnimationPlayer.play("Fadein")
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("Fadeout")
	healthbar.self_modulate.a = 0.0
