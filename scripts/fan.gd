extends StaticBody2D

@onready var animation = $AnimationPlayer
@onready var flow_area = $FlowArea/CollisionShape2D
@onready var particles = $GPUParticles2D
@onready var audio: AudioStreamPlayer2D = $FanAudio

func turn_on():
	animation.play("on")
	flow_area.disabled = false
	particles.emitting = true
	audio.play()

func turn_off():
	animation.play("off")
	flow_area.disabled = true
	particles.emitting = false
	audio.stop()

func _ready() -> void:
	turn_off()
