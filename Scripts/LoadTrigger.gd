extends Area

export var level : int

# List of scene paths
var levels : Array = [
	"res://Scenes/Levels/MainMenu.tscn",
	"res://Scenes/Levels/Level01.tscn",
	"res://Scenes/Levels/Level02.tscn",
	"res://Scenes/Levels/Level03.tscn",
	"res://Scenes/Levels/Level04.tscn",
	"res://Scenes/Levels/Level05.tscn",
]

# Loads the selected scene
func load_scene(_body):
	# Changes the rng seed
	randomize()
	# Resets values and loads scene
	if level != 4:
		References.battery = 100
		References.health = 80
		level = get_tree().change_scene(levels[level])
	else:
		# 1/4 chance of level05 getting loaded than level04
		if randi() % 4 < 1:
			References.battery = 100
			References.health = 80
			level = get_tree().change_scene(levels[5])
		else:
			References.battery = 100
			References.health = 80
			level = get_tree().change_scene(levels[4])
