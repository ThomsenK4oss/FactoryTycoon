extends PathFollow3D

var time: float = 10.0

func _physics_process(delta: float) -> void:
	progress += 2 * delta
	
	if progress_ratio == 1:
		time -= delta
		if time <= 0:
			print("Gone for good...")
			queue_free()
	else:
		if time < 10.0:
			time = 10.0
