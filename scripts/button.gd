extends Area2D

@export var node_path: NodePath
@onready var sprite: Sprite2D = $ButtonSprite

var node: Node
var active: bool = false

func _ready() -> void:
	node = get_node(node_path)

func activate():
	if node:
		if node.has_method("turn_on") and not active:
			node.turn_on()
			active = true
			sprite.texture = load("res://assets/off_button.png")
			sprite.scale = Vector2(3.5, 3.5)
		elif node.has_method("turn_off") and active:
			node.turn_off()
			active = false
			sprite.texture = load("res://assets/on_button.png")
			sprite.scale = Vector2i(2, 2)
