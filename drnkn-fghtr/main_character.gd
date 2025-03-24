class_name Player extends CharacterBody2D


@onready var healthbar: ProgressBar = $"../Healthbar/ProgressBar"

@onready var hitbox: Area2D = %Hitbox
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var knockbackPower: int = 200
@onready var mob: Mob = $"../Mob"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var max_health: int = 1000.0
var health: int = 1000.0


enum State { NORMAL, KNOCKBACK }
var current_state: int = State.NORMAL
var knockback_timer: float = 0.0  # Timer for knockback duration

func _ready() -> void:
	

	healthbar.max_value = max_health
	healthbar.value = health # Replace with function body.
	
	$Arm.set_deferred("disabled", true)
	hitbox.body_entered.connect(func (body: Node) -> void:
		if body is Mob:
			knockback(body.position)
	)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match current_state:
		State.NORMAL:
			handle_movement()
		State.KNOCKBACK:
			apply_knockback(delta)

	move_and_slide()
	
	if Input.is_action_just_pressed("punch"):
		animation_player.play("punch")

func _input(event):
	if event.is_action_pressed("punch"):  # Check if the attack button is pressed
		punch()
		
	if event.is_action_pressed("pick_up"):
		$AnimationPlayer.play("punch")
		print("picked")

func punch():
	if not $AnimationPlayer.is_playing():  # Prevent attack spam
		play_attack_animation()

func handle_movement():
	"""Handles normal movement and jumping."""
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
func is_attacking() -> bool:
	return $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "punch"

func knockback(mob_position: Vector2):
	"""Applies knockback away from the enemy."""
	if velocity.x == 0:  # Only knockback if standing still
		var knockbackDirection = (position - mob_position).normalized() * knockbackPower
		velocity = knockbackDirection
		current_state = State.KNOCKBACK
		knockback_timer = 0.3  # Knockback lasts for 0.3 seconds

func apply_knockback(delta: float):
	"""Handles knockback duration and gravity application."""
	knockback_timer -= delta
	
	# Apply gravity while in knockback
	if not is_on_floor():
		velocity += get_gravity() * delta

	if knockback_timer <= 0:
		current_state = State.NORMAL  # Return to normal movement

func take_damage():
	health -= 100  
	updateHealth()
	print("damage")
	if health <= 0:
		die()

func updateHealth():
	healthbar.value = health
	
func die():
	queue_free()


func play_attack_animation():
	$AnimationPlayer.play("punch")
	$Arm.set_deferred("disabled", false)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "punch":  # Ensure it's the attack animation
		$Arm.set_deferred("disabled", true)
