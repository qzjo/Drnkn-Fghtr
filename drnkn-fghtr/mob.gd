class_name Mob extends CharacterBody2D

@onready var target = $"../Character"
var health: int = 100
const speed = 100.0
@onready var hitbox: Area2D = $Hitbox
@onready var knockbackPower: int = 500
var is_dead = false
enum State { CHASING, KNOCKBACK }
var current_state: int = State.CHASING  # Start in chasing mode
var knockback_timer: float = 0.0  # Timer for knockback duration

func _ready() -> void:
	hitbox.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match current_state:
		State.CHASING:
			chase_player()
		State.KNOCKBACK:
			apply_knockback(delta)

	move_and_slide()

func take_damage(amount: int):
	if is_dead: 
		return
	health -= 100
	print("Mob took", amount, "damage! Health:", health)

	if health <= 0:
		is_dead = true
		set_deferred("monitoring", false)  
		queue_free()


func chase_player():
	if target and is_instance_valid(target):
		var direction = (target.position - position).normalized()
		velocity = direction * speed
	else:
		get_tree().quit()

func knockback():
	var knockbackDirection = (position - target.position).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	
	current_state = State.KNOCKBACK
	knockback_timer = 0.3

func apply_knockback(delta: float):
	if not is_inside_tree():  
		return
	knockback_timer -= delta
	
	# Apply gravity while in knockback state
	if not is_on_floor():
		velocity += get_gravity() * delta  # Ensures mob falls normally

	if knockback_timer <= 0:
		current_state = State.CHASING  # Return to chasing mode

func _on_Hitbox_area_entered(area):
	if area.is_in_group("player_attack"):
		take_damage(100)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		var player := body as Player
		if not player.is_attacking():
			player.take_damage()
		if player.is_attacking():  
			knockback()
