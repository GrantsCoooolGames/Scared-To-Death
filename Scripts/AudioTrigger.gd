extends Area

onready var audio : AudioStreamPlayer = $Audio

var audio_played : bool = false

func play_audio(_body):
	if audio_played == false:
		audio.play()
		audio_played = true
