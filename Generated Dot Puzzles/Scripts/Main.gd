extends Node2D

signal next_theme #for random colors
var next_scene_loaded
var scene_path = "res://Scenes/Levels/Level"
var scene_file_extension = ".tscn"
func _ready():
	_load_next_level(Global.level)

func _on_Level_complete():
	Global.level += 1
	self.remove_child($Level)
	_load_next_level(Global.level)

func _load_next_level(levelIndex): # Loads level of certain index
	emit_signal("next_theme")#for random colors
	
