extends CharacterBody3D

@export var move_speed := 7.5
@export var push_force := 4.0
@export var pull_distance := 1.2

@onready var animation_player: AnimationPlayer = $Body/AnimationPlayer
@onready var mesh_root: Node3D = $Body
@onready var push_ray: RayCast3D = $Body/PushRay

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var pull_mode := false
var is_pushing := false
var is_pulling := false
var last_anim := ""
var pulled_body: RigidBody3D = null

func _physics_process(delta):
	# TOGGLE PULL MODE
	if Input.is_action_just_pressed("pull_block"):
		pull_mode = !pull_mode
		if not pull_mode:
			release_block()
	
	# GRAVITY
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	
	# MOVEMENT
	var input := Input.get_vector("left", "right", "up", "down")
	var direction := Vector3(input.x, 0, input.y)

	if direction.length() > 0.1:
		direction = direction.normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		mesh_root.rotation.y = atan2(direction.x, direction.z)
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)

	move_and_slide()

	# RESET STATES
	is_pushing = false
	is_pulling = false

	# PUSH / PULL
	#if push_ray.is_colliding():
		#var body := push_ray.get_collider()
		#if body is RigidBody3D:
#
			#if pull_mode:
				## ---- PULL
				#is_pulling = true
				#pulled_body = body
				#pulled_body.freeze = true
#
				## ✅ CRITICAL FIX:
				## Player ignores block collision while pulling
				#collision_mask &= ~2
#
			#else:
				## ---- PUSH
				#is_pushing = true
				#var push_dir := -push_ray.global_transform.basis.z
				#push_dir.y = 0
				#push_dir = push_dir.normalized()
				#body.apply_central_impulse(push_dir * push_force)

	# MOVE PULLED BLOCK WITH PLAYER
	if pulled_body:
		var target_pos := global_position - push_ray.global_transform.basis.z * pull_distance
		target_pos.y = pulled_body.global_position.y
		pulled_body.global_position = target_pos

	# ANIMATION
	var horizontal_speed := Vector2(velocity.x, velocity.z).length()

	#if is_pulling:
		#play_anim("push", -1.0)
	#elif is_pushing:
		#play_anim("push", 1.0)
	#elif horizontal_speed > 0.2:
		#play_anim("Walk", 1.0)
	#else:
		#play_anim("Idle", 1.0)

func release_block():
	if pulled_body:
		pulled_body.freeze = false
		pulled_body = null

	collision_mask |= 2

#func play_anim(name: String, speed := 1.0):
	#if last_anim == name and animation_player.speed_scale == speed:
		#return
	#last_anim = name
	#animation_player.speed_scale = speed
	#animation_player.play(name)
