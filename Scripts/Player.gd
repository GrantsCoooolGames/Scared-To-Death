extends KinematicBody

# Camera
const MOUSE_SENSITIVITY : float = 0.075
onready var look_pivot : Spatial = $LookPivot

# Flashlight
const HEALTH_INCREASE : float = 7.5
const HEALTH_DECREASE : float = 5.0
const BATTERY_USAGE : float = 5.5
onready var spotlight : SpotLight = $LookPivot/SpotLight
onready var switch_sound : AudioStreamPlayer = $LookPivot/SwitchSound
onready var camera : Camera = $LookPivot/Camera
onready var footstep_audio : AudioStreamPlayer = $FootstepAudio
onready var footstep_timer : Timer = $FootstepTimer

# Movement
const MOVE_SPEED : float = 8.0
const acceleration : float = 8.0

# Gravity
const GRAVITY_FORCE : float = 4.0

# Changing variables
var movement : Vector3 = Vector3()
var gravity : Vector3 = Vector3()
var snap_vector : Vector3 = Vector3()

func _ready():
	# Adds the variables to references
	References.spotlight = spotlight
	References.player = self
	References.player_alive = true
	References.spawnpoint = transform.origin
	# Locks the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Moves the camera based on input
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-1 * event.relative.x * MOUSE_SENSITIVITY))
		look_pivot.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		look_pivot.rotation.x = clamp(look_pivot.rotation.x, deg2rad(-90), deg2rad(90))

func _process(delta):
	# Moves the flashlight camera
	References.flashlight_cam.global_transform = camera.global_transform
	
	# Turns on and off the flashlight
	if Input.is_action_just_pressed("flashlight_toggle"):
		if References.battery > 0:
			spotlight.visible = !spotlight.visible
			switch_sound.play()
	
	# Changes health and battery
	if spotlight.visible:
		References.health += HEALTH_DECREASE * delta
		References.battery -= BATTERY_USAGE * delta
	else:
		References.health -= HEALTH_INCREASE * delta
	
	if References.battery <= 0 and spotlight.visible:
		spotlight.visible = false
		switch_sound.play()

func _physics_process(delta):
	# Movement and Acceleration
	var direction : Vector3 = get_input_direction()
	movement = movement.linear_interpolate(direction * MOVE_SPEED, acceleration * delta)
	
	# Gravity and Snap
	if not is_on_floor():
		gravity += GRAVITY_FORCE * Vector3.DOWN * delta
		snap_vector = Vector3.ZERO
	else:
		gravity = GRAVITY_FORCE * Vector3.DOWN * delta
		snap_vector = -get_floor_normal()
	
	movement = move_and_slide_with_snap(movement + gravity, snap_vector, Vector3.UP)

func get_input_direction() -> Vector3:
	# Gets horizontal input
	var z : float = (
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	)
	
	var x : float = (
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	)
	
	# Multiplies values by the player's rotation
	return transform.basis.xform(Vector3(x, 0, z)).normalized()


func play_footstep():
	if get_input_direction() != Vector3.ZERO:
		footstep_audio.play()
		footstep_timer.start()
