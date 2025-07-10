extends StaticBody3D

@export var machine: Node3D

@export var spawn_pos: Marker3D

func _ready() -> void:
	update_velocity()

func update_velocity():
	if machine.rotation_degrees.y == 0:
		set_constant_linear_velocity(Vector3(0, 0, -2))
		print("forward")
	elif machine.rotation_degrees.y == -90:
		set_constant_linear_velocity(Vector3(2, 0, 0))
		print("right")
	elif machine.rotation_degrees.y == -180:
		set_constant_linear_velocity(Vector3(0, 0, 2))
		print("backward")
	elif machine.rotation_degrees.y == -270:
		set_constant_linear_velocity(Vector3(-2, 0, 0))
		print("left")

func _on_spawn_timer_timeout() -> void:
	machine.spawn_output(spawn_pos.global_position)
