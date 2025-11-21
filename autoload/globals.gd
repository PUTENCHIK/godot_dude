extends Node

const MAX_HEALTH = 10

const DEFAULT_VOLUME = 0.2

var health = MAX_HEALTH

func pause():
	get_tree().set_pause(true)

func resume():
	get_tree().set_pause(false)

func exit():
	get_tree().quit()
