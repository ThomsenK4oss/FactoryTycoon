extends Node3D

@onready var grid_map: GridMap = $GridMap

func _ready() -> void:
	place_wall(find_wall_placement())

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var hit = get_mouse_pos()
		if hit:
			get_tile_data(hit)

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

func get_tile_data(world_pos: Vector3):
	if world_pos:
		var local_pos = grid_map.to_local(world_pos)
		var map_pos = grid_map.local_to_map(local_pos) # Vector3i grid coordinate

		print("World Pos:", world_pos)
		print("Local Pos:", local_pos)
		print("Grid Pos (Vector3i):", map_pos)

		var cell_id = grid_map.get_cell_item(map_pos)

		if cell_id != -1:
			print("✅ Found cell ID:", cell_id)
		else:
			print("❌ No cell data at", map_pos)

func place_wall(wall_positions: Array):
	for wall_position in wall_positions:
		var wall_id = 1
		grid_map.set_cell_item(wall_position, wall_id)
		#var marker = MeshInstance3D.new()
		#marker.mesh = BoxMesh.new()
		#marker.transform.origin = wall_position
		#add_child(marker)

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
