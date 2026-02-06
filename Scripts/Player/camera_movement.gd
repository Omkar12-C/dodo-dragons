extends Node3D

@export var target : Node3D
@export var speed := 6.0
var offset : Vector3

func _ready() -> void:
	offset = global_position - target.global_position

func _process(delta):
	if target:
		global_position = global_position.lerp(target.global_position + offset, speed * delta)
