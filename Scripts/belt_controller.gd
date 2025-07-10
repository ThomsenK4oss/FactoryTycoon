extends Node

@onready var grid_map: GridMap = get_parent().get_node("Tiles/Map_System/GridMap")

@export var belts_holder: Node3D

@export var current_belt: Node3D

@export var can_place_texture: Resource

@export var cant_place_texture: Resource

@export var show_belt: bool = false

func _process(delta: float) -> void:
	if Database.selected_belt != {} and show_belt == false:
		show_belt = true
	
	if show_belt:
		if can_place():
			if Input.is_action_just_pressed("Click"):
				place_belt()

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

func get_tile_data(world_pos: Vector3) -> int:
	if world_pos:
		var local_pos = grid_map.to_local(world_pos)
		var map_pos = grid_map.local_to_map(local_pos)

		var cell_id = grid_map.get_cell_item(map_pos)

		if cell_id != -1:
			return cell_id
		else:
			return -1
	return -1

func is_floor(cell_id: int):
	return cell_id == 0

func place_on_grid(map_pos) -> Vector3:
	var grid_local_pos = grid_map.map_to_local(map_pos)
	var grid_pos = grid_map.to_global(grid_local_pos)
	
	return grid_pos

func check_grid_pos(pos):
	for i in Database.placed_belts:
		if Database.placed_belts[i] == pos:
			return false
	for i in Database.placed_machines:
		if Database.placed_machines[i] == pos:
			return false
	return true

func rotate():
	if Input.is_action_just_pressed("r"):
		current_belt.rotation_degrees.y -= 90

func can_place() -> bool:
	var mouse_pos = get_mouse_pos()
	if mouse_pos:
		if current_belt.get_child_count() > 0:
			if current_belt.get_child(0).belt_name != Database.selected_belt["Name"]:
				current_belt.get_child(0).queue_free()
				
				var instance = load(Database.selected_belt["Scene"]).instantiate()
				current_belt.add_child(instance)
		else:
			var instance = load(Database.selected_belt["Scene"]).instantiate()
			current_belt.add_child(instance)
		
		var local_pos = grid_map.to_local(mouse_pos)
		var map_pos = grid_map.local_to_map(local_pos)
		var pos = Vector3(place_on_grid(map_pos).x, 0.5, place_on_grid(map_pos).z)
		
		current_belt.global_position = pos
		rotate()
		
		if check_grid_pos(pos):
			if is_floor(get_tile_data(mouse_pos)):
				if Database.current_save["Gold"] >= Database.selected_belt["Cost"]:
					current_belt.visible = true
					for part in current_belt.get_child(0).belt_parts:
						part.material_override = can_place_texture
					return true
				else:
					current_belt.visible = true
					for part in current_belt.get_child(0).belt_parts:
						part.material_override = cant_place_texture
					return false
			else:
				current_belt.visible = false
				for part in current_belt.get_child(0).belt_parts:
					part.material_override = cant_place_texture
				return false
		else:
			current_belt.visible = true
			for part in current_belt.get_child(0).belt_parts:
				part.material_override = cant_place_texture
			return false
	else:
		current_belt.visible = false
		return false

func place_belt():
	var mouse_pos = get_mouse_pos()
	if mouse_pos:
		var local_pos = grid_map.to_local(mouse_pos)
		var map_pos = grid_map.local_to_map(local_pos)
		var pos = Vector3(place_on_grid(map_pos).x, 0.5, place_on_grid(map_pos).z)
		
		if Input.is_action_pressed("Shift"):
			var instance = load(Database.selected_belt["Scene"]).instantiate()
			belts_holder.add_child(instance)
			instance.global_position = Vector3(pos.x, 0.5, pos.z)
			instance.rotation_degrees = current_belt.rotation_degrees
			Database.placed_belts[Database.placed_belts.size()] = instance.global_position
			instance.activate()
		else:
			var instance = load(Database.selected_belt["Scene"]).instantiate()
			belts_holder.add_child(instance)
			instance.global_position = Vector3(pos.x, 0.5, pos.z)
			instance.rotation_degrees = current_belt.rotation_degrees
			Database.placed_belts[Database.placed_belts.size()] = instance.global_position
			
			instance.activate()
			
			Database.selected_belt = {}
			show_belt = false
			
			current_belt.visible = false
