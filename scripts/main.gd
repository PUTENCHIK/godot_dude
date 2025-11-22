extends Node2D

@onready var menu: Node2D = $UI/Menu
@onready var player_scene = preload("res://scenes/physics_dude.tscn")
@onready var world = $World

var current_level: Node2D = null
var levels: Dictionary = {
	"Training": preload("res://scenes/training_level.tscn"),
	"Infinite": preload("res://scenes/infinity_level.tscn")
}
var player = null
var camera = null

func _ready() -> void:
	player = player_scene.instantiate()
	camera = player.get_node("Camera2D")
	world.add_child(player)
	if len(levels.keys()) == 0:
		print("[ERROR] No levels")
	var start_level = 1
	menu.update_levels(levels.keys(), start_level)
	load_level(levels.keys()[start_level])
	menu.level_changed.connect(load_level)

func load_level(level_name: String):
	if current_level:
		current_level.queue_free()
	current_level = levels[level_name].instantiate()
	world.add_child(current_level)
	player.global_position = current_level.get_node("Spawn").global_position
	
	match level_name:
		"Training": camera.enabled = false
		"Infinite":
			camera.enabled = true
			camera.limit_left = 0
			camera.limit_top = 0
			camera.limit_bottom = 648
			current_level.camera = camera
			current_level.player = player

func save_settings():
	var config = ConfigFile.new()
	var slider: HSlider = menu.get_node("CenterContainer/VBoxContainer/HBoxContainer/HSlider")
	config.set_value("audio", "volume", slider.value)
	config.save("user://dude.cfg")

func load_settings():
	var config = ConfigFile.new()
	var error = config.load("user://dude.cfg")
	if error == OK:
		var slider: HSlider = menu.get_node("CenterContainer/VBoxContainer/HBoxContainer/HSlider")
		var volume = config.get_value("audio", "volume", Globals.DEFAULT_VOLUME)
		slider.value = volume
