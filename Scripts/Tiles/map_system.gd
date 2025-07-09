extends Node3D

@onready var grid_map: GridMap = $GridMap

@export var highlight_mesh: Node3D

@export var can_buy: Resource
@export var cant_buy: Resource

func _ready() -> void:
	place_wall(find_wall_placement())
	load_floor()

func _unhandled_input(event):
	# Spawns floors at all wall spots
	################################ New spawning system
	if Input.is_action_just_pressed("upgrade_floor"):
		if Database.current_save["Gold"] >= Database.current_save["BaseFloorCost"]:
			upgrade_floor()
			Database.current_save["Gold"] -= Database.current_save["BaseFloorCost"]
	################################ New spawning system

# Gets the mouse position
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

# Gets the data of the tile that is in the passed global position
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

# Spawns floors at all wall spots
################################ New spawning system
# Loads floors
func load_floor():
	for time in Database.current_save["FloorUpgradeAmount"]:
		for cell in grid_map.get_used_cells():
			var cell_id = grid_map.get_cell_item(cell)
			if cell_id == 1:
				grid_map.set_cell_item(cell, 0)
		place_wall(find_wall_placement())

# expands floor
func upgrade_floor():
	for cell in grid_map.get_used_cells():
		var cell_id = grid_map.get_cell_item(cell)
		if cell_id == 1:
			grid_map.set_cell_item(cell, 0)
	place_wall(find_wall_placement())
	Database.current_save["FloorUpgradeAmount"] += 1

# Places walls
func place_wall(wall_positions: Array):
	for wall_position in wall_positions:
		var wall_id = 1
		grid_map.set_cell_item(wall_position, wall_id)

# Finds all the spots where a wall needs to be placed
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
################################ New spawning system
