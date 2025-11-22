extends StaticBody2D

func _on_character_step_platform(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.sticky_platform_step.emit()

func _on_character_leave_platform(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.sticky_platform_leave.emit()
