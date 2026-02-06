extends Node3D

@export var target: Node3D
@export var smooth := 6.0

func _process(delta):
	if target:
		global_position = global_position.lerp(
			target.global_position,
			smooth * delta
		)
