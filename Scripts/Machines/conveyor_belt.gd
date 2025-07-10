extends StaticBody3D

@export var speed: float = 2.0
@export var direction: Vector3 = Vector3.FORWARD

func _ready() -> void:
	set_constant_linear_velocity(get_parent().get_parent().global_transform.basis.z * -speed)
