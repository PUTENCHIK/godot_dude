extends RigidBody2D

var random = RandomNumberGenerator.new()
@onready var animation = get_node("AnimationPlayer")

func _ready() -> void:
	animation.play("idle")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var pos = get_global_mouse_position()
		var state = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = pos
		
		var results = state.intersect_point(query, 4)
		for result in results:
			var collider = result.collider
			if collider is RigidBody2D and "Rock" in collider.name:
				if event.button_index == MOUSE_BUTTON_LEFT:
					apply_impulse(Vector2.UP * 1000)
				elif event.button_index == MOUSE_BUTTON_RIGHT:
					var directon = Vector2(
						random.randf_range(-1, 1),
						random.randf_range(-1, 1)
					).normalized()
					apply_impulse(directon * 1000)
				break
