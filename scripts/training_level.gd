extends Node2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	#dude.hit.connect(_on_hit_static_box)
	audio_player.stream = load("res://audio/background.ogg")
	audio_player.play()
