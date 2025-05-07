class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hotbar: HBoxContainer = $UI/Hotbar
@onready var hitbox: Area2D = %Hitbox
@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var knockbackPower: int = 200
@onready var mob: Mob = $"../Mob"
var health: int = 100
var attacking: bool = false
@onready var door: Area2D = $"../Door"
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

const DASH_SPEED = 1000
var dashing = false
var can_dash = true

signal plrdied

enum State { NORMAL, KNOCKBACK }
var current_state: int = State.NORMAL
var knockback_timer: float = 0.0

func _ready() -> void:
	$Arm.set_deferred("disabled", true)
	$Hitbox.set_deferred("monitoring", false)
	
	hitbox.body_entered.connect(func (body: Node) -> void:
		if body is Mob and attacking:
			body.take_damage(get_punch_damage())
	)

	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_animation_finished)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match current_state:
		State.NORMAL:
			handle_movement()
		State.KNOCKBACK:
			apply_knockback(delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("punch"):
		punch()
	
	var direction := Input.get_axis("move_left", "move_right")
	update_animations(direction)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()

func punch():
	if not attacking:
		play_attack_animation()

func play_attack_animation():
	print("Playing attack animation")
	attacking = true
	animated_sprite_2d.play("Attack")
	$Hitbox.set_deferred("monitoring", true)

func _on_animated_sprite_animation_finished():
	if animated_sprite_2d.animation == "Attack":
		print("Attack animation finished")
		attacking = false
		$Hitbox.set_deferred("monitoring", false)

func handle_movement():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * (DASH_SPEED if dashing else SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func update_animations(input_axis):
	if attacking:
		return
	if not is_on_floor():
		animated_sprite_2d.flip_h = (input_axis > 0)
		animated_sprite_2d.play("Jump")
	elif input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis > 0)
		animated_sprite_2d.play("Walk")
	else:
		animated_sprite_2d.play("Idle")

func knockback(mob_position: Vector2):
	velocity = (position - mob_position).normalized() * knockbackPower
	current_state = State.KNOCKBACK
	knockback_timer = 0.3

func apply_knockback(delta: float):
	knockback_timer -= delta
	if not is_on_floor():
		velocity += get_gravity() * delta
	if knockback_timer <= 0:
		current_state = State.NORMAL

func take_damage(amount: int = 20):
	health -= amount
	print("damage taken:", amount)
	if health <= 0:
		die()

func die():
	plrdied.emit()

var active_skill: String = ""
var default_punch_damage: int = 100

func get_punch_damage() -> int:
	if active_skill == "STAB":
		return default_punch_damage * 2
	return default_punch_damage

func apply_skill_enhancement(skill_name: String):
	active_skill = skill_name

func clear_skill_enhancement():
	active_skill = ""

func add_item(stats, skill, custom_durability: int = -1):
	hotbar.add_item(stats, skill, custom_durability)

@onready var weapons: Node2D = $Weapons

func has_empty_slot():
	return weapons.is_available()

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true

func is_attacking() -> bool:
	return attacking
