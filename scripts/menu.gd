extends Node2D

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
