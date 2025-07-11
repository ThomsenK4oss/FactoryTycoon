extends Node3D

@onready var rotationx:Node3D = $CameraRotationX
@onready var camerazoom:Node3D = $CameraRotationX/CameraZoom
@onready var camera:Camera3D = $CameraRotationX/CameraZoom/Camera3D

var move_speed:float = 0.25
var move_target:Vector3

var rotate_speed:float = 1.0
var rotate_target:float
var mouse_sesitivity:float = 0.1

var zoom_speed:float = 1.5
var zoom_target:float
var zoom_min:float = -20
var zoom_max:float = 20

func _ready() -> void:
	move_target = position
	rotate_target = rotation_degrees.y
	zoom_target = camera.position.z

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Right_Click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_released("Right_Click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# get input directions
	var input_directions = Input.get_vector("left","right","up","down")
	var movement_directions = (transform.basis * Vector3(input_directions.x,0,input_directions.y)).normalized()
	var zoom_dir = (int(Input.is_action_just_pressed("zoom_out"))-
					int(Input.is_action_just_released("zoom_in")))
	
	move_target += move_speed * movement_directions
	zoom_target += zoom_dir * zoom_speed
	
	position = lerp(position, move_target, 0.05)
	rotation_degrees.y = lerp(rotation_degrees.y, rotate_target, 0.05)
	camera.position.z = lerp(camera.position.z, zoom_target, 0.1)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("Right_Click"):
		rotate_target -= event.relative.x * mouse_sesitivity
		rotationx.rotation_degrees.x -= event.relative.y * mouse_sesitivity
		rotationx.rotation_degrees.x = clamp(rotationx.rotation_degrees.x, -10, 90)
		
