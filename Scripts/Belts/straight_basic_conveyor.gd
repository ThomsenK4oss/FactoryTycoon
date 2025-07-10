extends Node3D

var belt_name: String = "Straight_Basic_Conveyor"

@export var belt_parts: Array[MeshInstance3D]

func activate():
	$Belt/StaticBody3D/CollisionShape3D.disabled = false
	$Side/StaticBody3D/CollisionShape3D.disabled = false
	$Side/StaticBody3D/CollisionShape3D2.disabled = false
	$Side2/StaticBody3D/CollisionShape3D.disabled = false
