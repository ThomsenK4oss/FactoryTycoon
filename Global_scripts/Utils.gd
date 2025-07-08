extends Node

const SAVE_FILE = "user://Savefiletestv1.0.0.save"
var data = {}

func _ready() -> void:
	load_data()

func save_data():
	# Save data if file exists
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	data = {
		"Saves" : Database.current_save,
	}
	file.store_var(data)
	file = null

func load_data():
	# Create save file if it doesn't exist already
	if ! FileAccess.file_exists(SAVE_FILE):
		data = {
			"Saves" : Database.current_save,
		}
		save_data()
	
	# Load Data from save file
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	data = file.get_var()
	
	Database.current_save = data["Saves"]
	
	file = null
