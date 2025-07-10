extends Node3D

var machine_name: String = "Test"

@export var machine_parts: Array[MeshInstance3D]

@export var spawn_timer: Timer

@export var output: PackedScene

func start_output():
	spawn_timer.start()

func spawn_output(output_position: Vector3):
	var instance = output.instantiate()
	get_tree().get_first_node_in_group("FactoryNode").get_node("Output_Holder").add_child(instance)
	instance.global_position = output_position
