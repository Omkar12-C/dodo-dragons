extends RigidBody3D

@export var roll_force := 18.0

func _physics_process(delta):
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if input_dir.length() > 0:
		input_dir = input_dir.normalized()

	# Apply force so the ball rolls
	var force := Vector3(input_dir.x, 0, input_dir.y) * roll_force
	apply_central_force(force)
