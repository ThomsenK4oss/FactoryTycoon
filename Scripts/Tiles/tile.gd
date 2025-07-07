extends Node3D

@onready var walls: Node3D = $Walls

func remove_wall(wall):
	wall.visible = false

func _on_left_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("Wall"):
		remove_wall(area.get_parent())

func _on_right_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("Wall"):
		remove_wall(area.get_parent())

func _on_up_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("Wall"):
		remove_wall(area.get_parent())

func _on_down_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("Wall"):
		remove_wall(area.get_parent())
