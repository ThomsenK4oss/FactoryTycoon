extends Node

@onready var grid_map: GridMap = get_parent().get_node("Tiles/Map_System/GridMap")

var belt_at_pos: bool
var machine_at_pos: bool

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Left_Click"):
		delete_machine()
		delete_belt()

func get_mouse_pos():
	var mouse_pos = get_viewport().get_mouse_position()
	
	var camera = get_viewport().get_camera_3d()
	var origin = camera.project_ray_origin(mouse_pos)
	var direction = camera.project_ray_normal(mouse_pos)
	
	var space_state = get_parent().get_world_3d().direct_space_state
	var ray_length = 1000
	var end = origin + direction * ray_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	
	if result:
		var mouse_position_3D = result["position"]
		return mouse_position_3D
	return null

func get_structure():
	var mouse_pos = get_viewport().get_mouse_position()
	
	var camera = get_viewport().get_camera_3d()
	var origin = camera.project_ray_origin(mouse_pos)
	var direction = camera.project_ray_normal(mouse_pos)
	
	var space_state = get_parent().get_world_3d().direct_space_state
	var ray_length = 1000
	var end = origin + direction * ray_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	
	if result:
		var stucture = result["collider"]
		return stucture
	return null

func place_on_grid(map_pos) -> Vector3:
	var grid_local_pos = grid_map.map_to_local(map_pos)
	var grid_pos = grid_map.to_global(grid_local_pos)
	
	return Vector3(grid_pos.x, 0.5, grid_pos.z)

func check_grid_pos(pos):
	for i in Database.placed_belts:
		if Database.placed_belts[i] == pos:
			belt_at_pos = true
			machine_at_pos = false
			return
	
	for i in Database.placed_machines:
		if Database.placed_machines[i] == pos:
			machine_at_pos = true
			belt_at_pos = false
			return
	
	belt_at_pos = false
	machine_at_pos = false

func delete_machine():
	if Database.delete_mode:
		var mouse_pos = get_mouse_pos()
		if mouse_pos != null:
			var local_pos = grid_map.to_local(mouse_pos)
			var map_pos = grid_map.local_to_map(local_pos)
			var grid_pos = place_on_grid(map_pos)
			
			check_grid_pos(grid_pos)
			if machine_at_pos:
				for i in Database.placed_machines:
					if Database.placed_machines[i] == grid_pos:
						Database.current_save["Gold"] += get_structure().get_parent().return_amount
						Database.placed_machines.erase(i)
						get_structure().get_parent().delete_items()
						get_structure().get_parent().queue_free()
						break

func delete_belt():
	if Database.delete_mode:
		var mouse_pos = get_mouse_pos()
		if mouse_pos != null:
			var local_pos = grid_map.to_local(mouse_pos)
			var map_pos = grid_map.local_to_map(local_pos)
			var grid_pos = place_on_grid(map_pos)
			
			check_grid_pos(grid_pos)
			if belt_at_pos:
				for i in Database.placed_belts:
					if Database.placed_belts[i] == grid_pos:
						Database.current_save["Gold"] += get_structure().get_parent().return_amount
						Database.placed_belts.erase(i)
						get_structure().get_parent().delete_items()
						get_structure().get_parent().queue_free()
						break
