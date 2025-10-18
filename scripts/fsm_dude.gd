extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 800.0
const STUN_TIME = 0.5
enum State {IDLE, RUN, JUMP, DOUBLE_JUMP, STUN}

@onready var animation = get_node("AnimationPlayer")
@onready var sprite = get_node("DudeSprite")

var current_state: State = State.IDLE
var double_jump: bool = false
var stun_delay: float = 0.0

signal hit

func set_state(new_state: State):
	current_state = new_state

func _ready() -> void:
	set_state(State.IDLE)

func handle_idle(delta: float):
	animation.play("idle")
	
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
		set_state(State.RUN)
	else:
		#velocity.x *= 0
		velocity.x = move_toward(velocity.x, 0, SPEED / 20)
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		double_jump = true
		set_state(State.JUMP)

func handle_run(delta: float):
	animation.play("run")
	
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		set_state(State.IDLE)
		return
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		double_jump = true
		set_state(State.JUMP)

func update_flip():
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		sprite.flip_h = velocity.x < 0

func handle_collisions(delta: float):
	var platform = null
	var collision_count = get_slide_collision_count()
	for c in collision_count:
		var collision = get_slide_collision(c)
		var collider = collision.get_collider()
		var normal = collision.get_normal()
		if "StaticBox" in collider.name:
			if abs(normal.y) > 0.8:
				var force = 4 if normal.y > 0 else 1.5
				hit.emit()
				velocity = normal * SPEED * force
				set_state(State.JUMP)
		elif "Wall" in collider.name:
			if abs(normal.x) > 0.8:
				velocity = normal * SPEED
				stun_delay = STUN_TIME
				set_state(State.STUN)
		elif "Bridge" in collider.name:
			platform = collider
	if Input.is_action_pressed("down") and platform != null:
		var collision = platform.get_child(0)
		collision.disabled = true
		await get_tree().create_timer(0.1).timeout
		collision.disabled = false

func handle_jump(delta: float):
	animation.play("jump")
	
	if Input.is_action_just_pressed("jump") and double_jump:
		velocity.y = JUMP_VELOCITY
		double_jump = false
		set_state(State.DOUBLE_JUMP)
	
	var direction = Input.get_axis("left", "right")
	velocity.x = lerp(velocity.x, direction * SPEED, 0.2)

func handle_double_jump(delta: float):
	animation.play("double_jump")
	
	if velocity.y > 0:
		set_state(State.JUMP)
	
	var direction = Input.get_axis("left", "right")
	velocity.x = lerp(velocity.x, direction * SPEED, 0.2)

func handle_stun(delta: float):
	if stun_delay <= 0:
		set_state(State.JUMP)
	stun_delay -= delta

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			handle_idle(delta)
		State.RUN:
			handle_run(delta)
		State.JUMP:
			handle_jump(delta)
		State.DOUBLE_JUMP:
			handle_double_jump(delta)
		State.STUN:
			handle_stun(delta)
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	handle_collisions(delta)
	update_flip()
	move_and_slide()
	
	if is_on_floor() and current_state in [State.JUMP, State.DOUBLE_JUMP]:
		set_state(State.RUN if abs(velocity.x) > 0 else State.IDLE)
	if not is_on_floor() and current_state in [State.IDLE, State.RUN]:
		set_state(State.JUMP)
