extends CharacterBody3D

@export var move_pause := 0.5
@export var push_force := 4.0
@export var pull_distance := 1.2
var lastPos : Vector2
var targetPos : Vector2
var pos : Vector2
var targetRot : float
var backed_up : bool 

#@onready var animation_player: AnimationPlayer = $Body/AnimationPlayer
@onready var body: Node3D = $Body
#@onready var push_ray: RayCast3D = $Body/PushRay
@onready var movement_timer : Timer = $MovementTimer

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var pull_mode := false
var is_pushing := false
var is_pulling := false
var last_anim := ""
var pulled_body: RigidBody3D = null

func _ready() -> void:
	pos = Vector2(position.x, position.z)
	lastPos = pos
	targetPos = pos

func _input(event: InputEvent) -> void:
	
	if movement_timer.time_left == 0:
		var up = event.is_action("up")
		var down = event.is_action("down")
		var left = event.is_action("left")
		var right = event.is_action("right")
		
		if up or down or left or right:
			if pos.distance_to(targetPos) < 0.1:
				lastPos = targetPos
			
			movement_timer.start(move_pause)
			backed_up = false
			print("po")
		
		if up:
			if targetRot == PI:
				targetPos += Vector2.UP
			else:
				movement_timer.start(0.2)
			targetRot = PI
		elif down:
			if targetRot == 0:
				targetPos += Vector2.DOWN
			else:
				movement_timer.start(0.2)
			targetRot = 0
		elif left:
			if targetRot == -PI/2:
				targetPos += Vector2.LEFT
			else:
				movement_timer.start(0.2)
			targetRot = -PI/2
		elif right:
			if targetRot == PI/2:
				targetPos += Vector2.RIGHT
			else:
				movement_timer.start(0.2)
			targetRot = PI/2

func _physics_process(delta):
	# TOGGLE PULL MODE
	#if Input.is_action_just_pressed("pull_block"):
		#pull_mode = !pull_mode
		#if not pull_mode:
			#release_block()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	
	var speed = delta/move_pause
	position.x = move_toward(position.x, targetPos.x, speed)
	position.z = move_toward(position.z, targetPos.y, speed)
	
	body.rotation.y = lerp_angle(body.rotation.y, targetRot, 0.5)
	pos = Vector2(position.x, position.z)
	
	if pos.distance_to(targetPos) > 0.1 and movement_timer.time_left == 0 and !backed_up:
		targetPos = lastPos
		backed_up = true
		print("op")
	move_and_slide()


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
	#if pulled_body:
		#var target_pos := global_position - push_ray.global_transform.basis.z * pull_distance
		#target_pos.y = pulled_body.global_position.y
		#pulled_body.global_position = target_pos

	# ANIMATION
	#var horizontal_speed := Vector2(velocity.x, velocity.z).length()

	#if is_pulling:
		#play_anim("push", -1.0)
	#elif is_pushing:
		#play_anim("push", 1.0)
	#elif horizontal_speed > 0.2:
		#play_anim("Walk", 1.0)
	#else:
		#play_anim("Idle", 1.0)

#func release_block():
	#if pulled_body:
		#pulled_body.freeze = false
		#pulled_body = null
#
	#collision_mask |= 2

#func play_anim(name: String, speed := 1.0):
	#if last_anim == name and animation_player.speed_scale == speed:
		#return
	#last_anim = name
	#animation_player.speed_scale = speed
	#animation_player.play(name)
