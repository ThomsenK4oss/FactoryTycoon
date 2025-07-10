extends Panel

@export var belts_level_1: GridContainer

func _ready() -> void:
	for i in belts_level_1.get_child_count():
		var button = belts_level_1.get_child(i)
		button.connect("pressed", Callable(self, "level_1_Pressed").bind(i))

func level_1_Pressed(slot_index: int):
	var button = belts_level_1.get_child(slot_index)
	
	Database.selected_machine = {}
	Database.selected_belt = Database.conveyor_belts[str(button.name)]
	
	visible = false
