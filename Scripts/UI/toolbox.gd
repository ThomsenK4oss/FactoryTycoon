extends Panel

@export var ESC_UI: GridContainer

@onready var container: GridContainer = $GridContainer

func _ready() -> void:
	for i in container.get_child_count():
		var button = container.get_child(i)
		button.connect("pressed", Callable(self, "tool_button_pressed").bind(i))

func tool_button_pressed(slot_index: int):
	var button = container.get_child(slot_index)
	if button.name == "UI":
		ESC_UI.visible = !ESC_UI.visible
