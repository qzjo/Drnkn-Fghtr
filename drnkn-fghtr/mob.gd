class_name Mob extends CharacterBody2D

@onready var target = $"../Character"

const speed = 200.0
@onready var hitbox: Area2D = $Hitbox
@onready var knockbackPower: int = 500

enum State { CHASING, KNOCKBACK }
var current_state: int = State.CHASING  # Start in chasing mode
var knockback_timer: float = 0.0  # Timer for knockback duration

func _ready() -> void:
	hitbox.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			knockback()
	)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match current_state:
		State.CHASING:
			chase_player()
		State.KNOCKBACK:
			apply_knockback(delta)

	move_and_slide()

func chase_player():
	"""Moves the mob towards the player."""
	var direction = (target.position - position).normalized()
	velocity = direction * speed

func knockback():
	"""Applies knockback in the direction away from the player."""
	var knockbackDirection = (position - target.position).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	
	current_state = State.KNOCKBACK
	knockback_timer = 0.3

func apply_knockback(delta: float):
	"""Handles knockback physics while allowing gravity to affect the mob."""
	knockback_timer -= delta
	
	# Apply gravity while in knockback state
	if not is_on_floor():
		velocity += get_gravity() * delta  # Ensures mob falls normally

	if knockback_timer <= 0:
		current_state = State.CHASING  # Return to chasing mode
