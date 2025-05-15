class_name Boss extends CharacterBody2D

@onready var target = $"../Character"
var health: int = 1000
const speed = 400.0
const GRAVITY = 980.0
@onready var hitbox: Area2D = $Hitbox
@onready var knockbackPower: int = 800
var is_dead = false
enum State { CHASING, KNOCKBACK }
var current_state: int = State.CHASING  # Start in chasing mode
var knockback_timer: float = 0.0  # Timer for knockback duration
@onready var mob_healthbar: ProgressBar = $mobHealthbar
@onready var animation_player: AnimationPlayer = $mobHealthbar/AnimationPlayer
@export var dmg:int = 5
var is_attacking = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal mobdied
signal mobhit
signal bossdied

func _ready() -> void:
	mob_healthbar.max_value = health

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	
	match current_state:
		State.CHASING:
			chase_player()
		State.KNOCKBACK:
			apply_knockback(delta)
	update_animations()

	move_and_slide()

	
	
func take_damage(amount:int):
	
	mobhit.emit()
	
	mob_healthbar.value = health
	
	if is_dead: 
		return
	health -= dmg
	print("Mob took ", dmg, " damage! Health:", health)

	if health <= 0:
		is_dead = true
		mobdied.emit()
		set_deferred("monitoring", false)
		

		
		queue_free()


func chase_player():

	
	if target and is_instance_valid(target):
		var direction = (target.position - position).normalized()
		velocity.x = direction.x * speed
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



func _on_hitbox_body_entered(body: Node) -> void:
	if not $Hitbox.monitoring:
		return
		
	if body is Player:
		var player := body as Player
		#animated_sprite_2d.play("Attack")
		#is_attacking = true
		if player.is_attacking():
			HitStopManager.hit_stop_short()
			knockback()
		$Hitbox.set_deferred("monitoring", false)
		await get_tree().create_timer(0.5).timeout
		#is_attacking = false
		$Hitbox.set_deferred("monitoring", true)

func start_attack_hitbox():
	$AttackHitbox.monitoring = false
	#$AttackHitbox/CollisionShape2D.disabled = false

func stop_attack_hitbox():
	$AttackHitbox.monitoring = true
	#$AttackHitbox/CollisionShape2D.disabled = true

func do_attack():
	print("doing attack")
	is_attacking = true
	animated_sprite_2d.play("Attack")
	start_attack_hitbox()
	await get_tree().create_timer(0.3).timeout  
	stop_attack_hitbox()
	is_attacking = false
	

func update_animations():
	if is_attacking:
		return
	animated_sprite_2d.play("Walk")


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		do_attack()
		var player := body as Player
		body.take_damage()
		HitStopManager.hit_stop_short()
		player.knockback(position)
