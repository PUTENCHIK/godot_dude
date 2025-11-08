extends Node2D

@onready var staticbox_animation = get_node("Static/StaticBox/AnimationPlayer")
@onready var dude = get_node("PhysicsDude")
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	dude.hit.connect(_on_hit_static_box)
	audio_player.stream = load("res://audio/background.ogg")
	audio_player.volume_db = linear_to_db(0.5)
	audio_player.play()

func _on_hit_static_box():
	staticbox_animation.play("hit")
