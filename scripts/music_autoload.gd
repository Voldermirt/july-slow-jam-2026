extends Node

@export_subgroup("Nodes")
@export var shop_music: AudioStreamPlayer
@export var overworld_music: AudioStreamPlayer

func play(song: String):
	match song:
		"shop": 
			overworld_music.stop()
			shop_music.play()
		"overworld":
			shop_music.stop()
			overworld_music.play()
