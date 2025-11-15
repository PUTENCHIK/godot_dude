extends Node

@export var health_texture: Texture2D

func _ready() -> void:
	update_health()

func update_health():
	var panel: Panel = $Panel
	var container: HBoxContainer = $Panel/HBoxContainer
	if panel and container:
		for child in container.get_children():
			child.queue_free()
		for i in Globals.health:
			var health = TextureRect.new()
			health.texture = health_texture
			health.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			container.add_child(health)
