extends StaticBody2D

const MAX_Y_DELTA = 150.0
const SPEED = 5.0
const MOVING_TIME = 2.0

var start_y: float
var stop_y: float
var direction: bool = false

func _ready() -> void:
	start_y = global_position.y - MAX_Y_DELTA
	stop_y = global_position.y + MAX_Y_DELTA

func _process(delta: float) -> void:
	if direction:
		if global_position.y < stop_y:
			global_position.y += SPEED
		else:
			direction = not direction
	else:
		if global_position.y > start_y:
			global_position.y -= SPEED
		else:
			direction = not direction
