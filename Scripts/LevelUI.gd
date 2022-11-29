extends CanvasLayer

onready var health_bar : ProgressBar = $Control/HealthBar
onready var death_screen : ColorRect = $Control/DeathScreen
onready var death_message : Label = $Control/DeathScreen/VBoxContainer/DeathMessage
onready var death_sound : AudioStreamPlayer = $DeathSound
onready var viewport : Viewport = $Control/ViewportContainer/Viewport

const player_scene : PackedScene = preload("res://Scenes/Player.tscn")

var death_messages : Array = [
	"dead as a doornail.",
	"better safe than sorry!",
	"scared to death!",
	"not the sharpest tool\nin the shed",
	"not the sharpest knife\nin the drawer"
]

var set_death_message : bool = false

func _ready():
	References.flashlight_cam = $Control/ViewportContainer/Viewport/Camera

func _process(_delta):
	if Input.is_action_just_pressed("exit_to_menu"):
		var _i = get_tree().change_scene("res://Scenes/Levels/MainMenu.tscn")
	
	# Displays death screen
	if References.health <= 0:
		if !set_death_message:
			death_message.text = death_messages[randi() % death_messages.size()]
			set_death_message = true
		death_screen.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Removes player from scene
		if References.player != null:
			References.player.queue_free()
			References.player = null
			death_sound.play()
	else:
		# Changes health bar UI
		References.health = clamp(References.health, health_bar.min_value, health_bar.max_value)
		health_bar.value = References.health
	
	# Respawns the player at their last checkpoint
	if death_screen.visible:
		if Input.is_action_just_pressed("player_respawn"):
			var player_spawn : Vector3 = References.spawnpoint
			var player : KinematicBody = player_scene.instance()
			
			References.health = 80
			References.battery = 100
			self.get_parent().add_child(player)
			player.global_translation = player_spawn
			References.spawnpoint = player_spawn
			death_screen.visible = false
			set_death_message = false
