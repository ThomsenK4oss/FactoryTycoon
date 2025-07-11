extends Node3D

var outputs: Array[PathFollow3D]

var return_amount: float

@export var belt_name: String

@export var belt_parts: Array[MeshInstance3D]

@export var path: Path3D

const TEST_BASIC_OUTPUT = preload("res://Scenes/Machines/Output/test_output.tscn")

var active: bool = false

func activate_collision():
	$StaticBody3D/CollisionShape3D.disabled = false

func delete_items():
	active = false
	for i in outputs:
		outputs.erase(i)
	
	for i in path.get_children():
		i.queue_free()

func _process(delta: float) -> void:
	if active:
		for i in outputs:
			if i != null:
				if i.progress_ratio == 1:
					outputs.erase(i)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if active:
		if area.get_parent().is_in_group("Output"):
			if !outputs.has(area.get_parent()):
				area.get_parent().reparent(path)
				area.get_parent().progress_ratio = 0
				outputs.append(area.get_parent())
