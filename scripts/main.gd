extends Node2D

@onready var staticbox_animation = get_node("Static/StaticBox/AnimationPlayer")
@onready var dude = get_node("PhysicsDude")
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var menu: Node = $Menu

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("menu"):
		#if menu.visible:
			#Globals.resume()
			#menu.hide()
		#else:
			#Globals.pause()
			#menu.show()

func _ready() -> void:
	dude.hit.connect(_on_hit_static_box)
	audio_player.stream = load("res://audio/background.ogg")
	audio_player.volume_db = linear_to_db(0.5)
	audio_player.play()

func _on_hit_static_box():
	staticbox_animation.play("hit")
