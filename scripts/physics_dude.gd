extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 800.0

@onready var animation = get_node("AnimationPlayer")
@onready var sprite = get_node("DudeSprite")

var is_double_jump: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_up") and not is_on_floor() and not is_double_jump:
		velocity.y = JUMP_VELOCITY / 1.3
		is_double_jump = true
	
	if direction != 0:
		sprite.flip_h = direction < 0
	
	if not is_on_floor():
		animation.play("double_jump" if is_double_jump else "jump")
	elif direction != 0:
		animation.play("run")
		is_double_jump = false
	else:
		animation.play("idle")
		is_double_jump = false
	
	move_and_slide()
