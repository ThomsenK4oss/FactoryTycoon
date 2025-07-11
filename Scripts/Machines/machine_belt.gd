extends Node3D

var machine_name: String = "Test"

var return_amount: float

@export var path: Path3D

@export var machine_parts: Array[MeshInstance3D]

@export var spawn_timer: Timer

@export var output: PackedScene

func delete_items():
	for i in path.get_children():
		i.queue_free()

func activate_collision():
	$StaticBody3D/CollisionShape3D.disabled = false

func start_output():
	spawn_timer.start()

func spawn_output():
	var instance = output.instantiate()
	path.add_child(instance)

func _on_spawn_timer_timeout() -> void:
	spawn_output()
