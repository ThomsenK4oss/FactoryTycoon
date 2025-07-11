extends Panel

@onready var container: GridContainer = $GridContainer

@export var Pause_Menu: GridContainer

@export var Belt_Menu: Panel

@export var delete_indicator: Panel

func _ready() -> void:
	for i in container.get_child_count():
		var button = container.get_child(i)
		button.connect("pressed", Callable(self, "tool_button_pressed").bind(i))

func tool_button_pressed(slot_index: int):
	var button = container.get_child(slot_index)
	if button.name == "UI":
		Pause_Menu.visible = !Pause_Menu.visible
		get_tree().paused = !get_tree().paused
	elif button.name == "Belts":
		Belt_Menu.visible = !Belt_Menu.visible

func _on_delete_machines_pressed() -> void:
	if Database.delete_mode == false:
		Database.delete_mode = true
		delete_indicator.visible = true
	else:
		Database.delete_mode = false
		delete_indicator.visible = false
