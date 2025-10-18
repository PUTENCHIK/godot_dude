extends Node2D

@onready var animation = get_node("AnimationPlayer")
@onready var sprite = get_node("DudeSprite")

var state: String = "idle"

func _process(delta: float) -> void:
	if state == "idle" and animation.current_animation != "idle":
		animation.play("idle")
	elif state == "run" and animation.current_animation != "run":
		animation.play("run")
	elif state == "jump" and animation.current_animation != "jump":
		animation.play("jump")
	
	if Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		state = "run"
	elif Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		state = "run"
	elif Input.is_action_pressed("ui_up"):
		state = "jump"
	else:
		state = "idle"
