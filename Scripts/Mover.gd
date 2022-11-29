extends KinematicBody

export var move_to : Vector3 = Vector3()
export var speed : float = 5

onready var pos1 : Vector3 = transform.origin
onready var pos2 : Vector3 = transform.origin + move_to
onready var destination : Vector3 = pos2

func _physics_process(_delta):
	var direction : Vector3
	
	# Moves towards destination at a constant speed
	if destination.distance_to(transform.origin) > 0.05:
		direction = destination - transform.origin
		direction = direction.normalized() * speed
		direction = move_and_slide(direction)
	else:
		# Snaps to desination and swaps destination
		transform.origin = destination
		if destination == pos2:
			destination = pos1
		else:
			destination = pos2
