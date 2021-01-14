extends Node2D

var importHelpPressed = false

func _ready():
	pass # Replace with function body.

func _on_LevelSelectButton_pressed():
	if importHelpPressed == false:
		get_tree().change_scene("res://LevelBrowser/LevelBrowser.tscn")

func _on_ImportHelpButton_pressed():
	importHelpPressed = true
	$ImportHelpPanel.show()

func _on_ExitImportHelpButton_pressed():
	importHelpPressed = false
	$ImportHelpPanel.hide()
