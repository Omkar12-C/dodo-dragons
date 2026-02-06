extends SpringArm3D

@export var smooth := 6.0

func _physics_process(delta):
	var player := get_parent().get_parent() as Node3D
	if player == null:
		return

	global_position = global_position.lerp(
		player.global_position,
		smooth * delta
	)
