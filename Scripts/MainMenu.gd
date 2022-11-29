extends Control

var master_bus : int = AudioServer.get_bus_index("Master")
onready var main_menu : VBoxContainer = $MarginContainer/MainMenu
onready var options_menu : VBoxContainer = $MarginContainer/OptionsMenu
onready var volume_slider : HSlider = $MarginContainer/OptionsMenu/Elements/Volume/VolumeSlider
onready var theme_audio : AudioStreamPlayer = $Theme_Audio

func _ready():
	volume_slider.value = AudioServer.get_bus_volume_db(master_bus)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Starts the game
func start_game():
	References.health = 80
	References.battery = 100
	var _i = get_tree().change_scene("res://Scenes/Levels/Level01.tscn")

# Quits the game
func quit_game():
	get_tree().quit()


func toggle_fullscreen():
	OS.window_fullscreen = !OS.window_fullscreen


func change_volume(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -18:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)


func open_options_menu():
	main_menu.visible = false
	options_menu.visible = true


func exit_options_menu():
	options_menu.visible = false
	main_menu.visible = true


func restart_music():
	theme_audio.play()
