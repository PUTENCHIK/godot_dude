extends Node2D

signal level_changed(name)

func _on_level_changed(value):
	_on_resume_button_pressed()
	var options = $CenterContainer/VBoxContainer/LevelsContainer/OptionButton
	level_changed.emit(options.get_item_text(value))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if visible:
			Globals.resume()
			hide()
		else:
			Globals.pause()
			show()

func _on_resume_button_pressed() -> void:
	Globals.resume()
	hide()

func _on_exit_button_pressed() -> void:
	Globals.exit()

func _on_h_slider_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus_idx, value)

func update_levels(levels: Array):
	var options = $CenterContainer/VBoxContainer/LevelsContainer/OptionButton
	for level in levels:
		options.add_item(level)
