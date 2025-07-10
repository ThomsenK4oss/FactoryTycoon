extends GridContainer

func _on_play_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_options_pressed() -> void:
	visible = false
	get_tree().paused = false
	#open options menu

func _on_menu_pressed() -> void:
	visible = false
	get_tree().paused = false
	#back to main menu

func _on_quit_pressed() -> void:
	Utils.save_data()
	get_tree().quit()
