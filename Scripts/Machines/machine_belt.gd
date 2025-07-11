extends Node3D

var machine_name: String = "Test"

@export var path: Path3D

@export var machine_parts: Array[MeshInstance3D]

@export var spawn_timer: Timer

@export var output: PackedScene

func start_output():
	spawn_timer.start()

func spawn_output():
	var instance = output.instantiate()
	path.add_child(instance)

func _on_spawn_timer_timeout() -> void:
	spawn_output()
