# CameraController.gd
# Attach this script to your Camera3D node. No additional InputMap setup required.

extends Camera3D

@export var move_speed := 10.0
@export var zoom_speed := 2.0
@export var rotation_speed := 0.2
@export var zoom_min := 5.0
@export var zoom_max := 40.0

var yaw := 0.0
var pitch := -30.0
var is_rotating := false

func _ready():
	# Start med den ønskede pitch/yaw
	rotation_degrees = Vector3(pitch, yaw, 0)

func _process(delta):
	_handle_movement(delta)

func _input(event):
	# Zoom med scrollhjul
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			_zoom(-1)
		elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			_zoom(1)
		# Start/stop rotation med højre museknap
		elif event.button_index == BUTTON_RIGHT:
			is_rotating = event.pressed
			Input.set_mouse_mode(is_rotating ? Input.MOUSE_MODE_CAPTURED : Input.MOUSE_MODE_VISIBLE)
	# Rotation når mus bevæger sig og højre knap holdes
	elif event is InputEventMouseMotion and is_rotating:
		yaw   -= event.relative.x * rotation_speed
		pitch -= event.relative.y * rotation_speed
		pitch  = clamp(pitch, -85, -10)
		rotation_degrees = Vector3(pitch, yaw, 0)

func _zoom(dir: int) -> void:
	# Zoom langs Y-aksen
	var pos = global_transform.origin
	pos.y = clamp(pos.y + dir * zoom_speed, zoom_min, zoom_max)
	global_transform.origin = pos

func _handle_movement(delta: float) -> void:
	var dir = Vector3.ZERO
	# Frem/tilbage i forhold til kameraets forward
	if Input.is_key_pressed(KEY_W):
		dir -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		dir += transform.basis.z
	# Strafe sideværts i forhold til kameraets right
	if Input.is_key_pressed(KEY_A):
		dir -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		dir += transform.basis.x

	dir.y = 0
	if dir != Vector3.ZERO:
		translate(dir.normalized() * move_speed * delta)
