extends Node3D

@onready var grid_map: GridMap = $GridMap

@export var highlight_mesh: Node3D

@export var can_buy: Resource
@export var cant_buy: Resource

func _ready() -> void:
	place_wall(find_wall_placement())

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var world_pos = get_mouse_pos()
		if world_pos:
			var local_pos = grid_map.to_local(world_pos)
			var map_pos = grid_map.local_to_map(local_pos)
			if get_tile_data(world_pos) == 1:
				highlight_wall(world_pos)
			else:
				highlight_mesh.visible = false
		else:
			highlight_mesh.visible = false
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var world_pos = get_mouse_pos()
		if world_pos:
			var local_pos = grid_map.to_local(world_pos)
			var map_pos = grid_map.local_to_map(local_pos)
			if get_tile_data(world_pos) == 1:
				if Database.current_save["Gold"] >= Database.current_save["BaseFloorCost"]:
					place_floor(map_pos)
					Database.current_save["Gold"] -= Database.current_save["BaseFloorCost"]

func get_mouse_pos():
	var mouse_pos = get_viewport().get_mouse_position()
	
	var camera = get_viewport().get_camera_3d()
	var origin = camera.project_ray_origin(mouse_pos)
	var direction = camera.project_ray_normal(mouse_pos)
	
	var space_state = get_world_3d().direct_space_state
	var ray_length = 1000
	var end = origin + direction * ray_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	
	if result:
		var mouse_position_3D = result["position"]
		return mouse_position_3D
	return null

func highlight_wall(world_pos):
	var local_pos = grid_map.to_local(world_pos)
	var map_pos = grid_map.local_to_map(local_pos)
	var global_pos = grid_map.to_global(grid_map.map_to_local(map_pos))
	
	highlight_mesh.global_position = Vector3(global_pos.x, 3.25, global_pos.z)
	
	highlight_mesh.visible = true
	
	if Database.current_save["Gold"] >= Database.current_save["BaseFloorCost"]:
		highlight_mesh.get_child(0).material_override = can_buy
	else:
		highlight_mesh.get_child(0).material_override = cant_buy

func get_tile_data(world_pos: Vector3) -> int:
	if world_pos:
		var local_pos = grid_map.to_local(world_pos)
		var map_pos = grid_map.local_to_map(local_pos)

		#print("World Pos:", world_pos)
		#print("Local Pos:", local_pos)
		#print("Grid Pos (Vector3i):", map_pos)

		var cell_id = grid_map.get_cell_item(map_pos)

		if cell_id != -1:
			#print("✅ Found cell ID:", cell_id)
			return cell_id
		else:
			#print("❌ No cell data at", map_pos)
			return -1
	return -1

func place_floor(map_pos):
	grid_map.set_cell_item(map_pos, 0)
	Database.current_save["FloorPlacement"][Database.current_save["FloorPlacement"].size() + 1] = map_pos
	print(Database.current_save)
	reset_walls()
	place_wall(find_wall_placement())

func reset_walls():
	for cell in grid_map.get_used_cells():
		var cell_id = grid_map.get_cell_item(cell)
		if cell_id == 1:
			grid_map.set_cell_item(cell, -1)

func place_wall(wall_positions: Array):
	for wall_position in wall_positions:
		var wall_id = 1
		grid_map.set_cell_item(wall_position, wall_id)

func find_wall_placement() -> Array:
	var wall_positions: Array[Vector3i]
	for cell in grid_map.get_used_cells():
		var cell_id = grid_map.get_cell_item(cell)
		var cell_pos = grid_map.map_to_local(cell)
		
		if grid_map.get_cell_item(Vector3(cell.x + 1, cell.y, cell.z)) != cell_id:
			wall_positions.append(Vector3i(cell.x + 1, cell.y, cell.z))
		
		if grid_map.get_cell_item(Vector3(cell.x - 1, cell.y, cell.z)) != cell_id:
			wall_positions.append(Vector3i(cell.x - 1, cell.y, cell.z))
		
		if grid_map.get_cell_item(Vector3(cell.x, cell.y, cell.z + 1)) != cell_id:
			wall_positions.append(Vector3i(cell.x, cell.y, cell.z + 1))
		
		if grid_map.get_cell_item(Vector3(cell.x, cell.y, cell.z - 1)) != cell_id:
			wall_positions.append(Vector3i(cell.x, cell.y, cell.z - 1))
		
		if grid_map.get_cell_item(Vector3(cell.x + 1, cell.y, cell.z + 1)) != cell_id:
			wall_positions.append(Vector3i(cell.x + 1, cell.y, cell.z + 1))
		
		if grid_map.get_cell_item(Vector3(cell.x - 1, cell.y, cell.z - 1)) != cell_id:
			wall_positions.append(Vector3i(cell.x - 1, cell.y, cell.z - 1))
		
		if grid_map.get_cell_item(Vector3(cell.x - 1, cell.y, cell.z + 1)) != cell_id:
			wall_positions.append(Vector3i(cell.x - 1, cell.y, cell.z + 1))
		
		if grid_map.get_cell_item(Vector3(cell.x + 1, cell.y, cell.z - 1)) != cell_id:
			wall_positions.append(Vector3i(cell.x + 1, cell.y, cell.z - 1))
	
	return wall_positions
