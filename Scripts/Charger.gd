extends Spatial

onready var charge_sound : AudioStreamPlayer3D = $Charge_Sound

func charge_flashlight(_body):
	References.battery = 100
	References.spotlight.visible = true
	charge_sound.play()
