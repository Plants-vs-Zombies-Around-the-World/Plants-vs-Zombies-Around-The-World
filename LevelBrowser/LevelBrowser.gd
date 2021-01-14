extends Node2D

func _ready():
	pass # Replace with function body.

func _on_MenuButton_pressed():
	get_tree().change_scene("res://Start.tscn")

func _on_LevelsButton_pressed():
	get_tree().change_scene("res://LevelBrowser/Suburbia/Suburbia.tscn")

func _on_CustomLevelsButton_pressed():
	get_tree().change_scene("res://LevelBrowser/CustomLevels/CustomLevels.tscn")
