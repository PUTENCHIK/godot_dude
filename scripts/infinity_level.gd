extends Node2D

@export var platform_scene: PackedScene
@export var slicky_platform_scene: PackedScene
@export var moving_platform_scene: PackedScene

@export var slicky_chance: float = 0.8
@export var moving_chance: float = 0.1

@export var offscreen_distance: float = 300.0
@export var min_gap: float = 100.0
@export var max_gap: float = 200.0
@export var gap_delta: float = 10.0
@export var min_y: float = 300.0
@export var max_y: float = 500.0

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var platforms: Node2D = $Platforms
@onready var spawn: Marker2D = $Spawn
@onready var score_label: Label = $ExtraUI/Score

var camera: Camera2D
var player: CharacterBody2D
var spawned_planforms: Array[Node] = []
var score: int = 0

var right_x: float = 0.0
var left_x: float = 0.0

func _ready() -> void:
	audio_player.play()
	if spawn:
		_spawn_platform(spawn.global_position.x)

func _process(delta: float) -> void:
	print(score)
	if not camera or not player or not platform_scene:
		print("Not need objects for platforms generation")
		return
	var screen_size = get_viewport_rect().size
	var camera_position = camera.global_position
	var half_w = screen_size.x / 2
	var left_edge = camera_position.x - half_w
	var right_edge = camera_position.x + half_w
	while right_x < right_edge + offscreen_distance:
		_spawn_platform(right_x + randf_range(min_gap, max_gap))
		right_x = spawned_planforms[-1].position.x
		_increase_score()
		if score > 10:
			min_gap += gap_delta
			max_gap += gap_delta
	
	for i in range(spawned_planforms.size()-1, -1, -1):
		var platform: StaticBody2D = spawned_planforms[i]
		if platform.position.x < left_edge - offscreen_distance:
			platform.queue_free()
			spawned_planforms.remove_at(i)

func _get_platform_scene() -> StaticBody2D:
	var chance = randf()
	if chance <= 1 - slicky_chance - moving_chance:
		return platform_scene.instantiate()
	elif chance <= 1 - moving_chance:
		return slicky_platform_scene.instantiate()
	else:
		return moving_platform_scene.instantiate()

func _spawn_platform(x: float):
	if not platform_scene or not slicky_platform_scene:
		return
	var platform: StaticBody2D = _get_platform_scene()
	platform.position.x = x
	platform.position.y = randf_range(min_y, max_y)
	platforms.add_child(platform)
	spawned_planforms.append(platform)

func _increase_score():
	score += 1
	score_label.text = str(score)
