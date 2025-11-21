extends Node2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	audio_player.play()
