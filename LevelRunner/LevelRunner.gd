extends Node2D

# variables for level data
var levelPath
var sun
var stage
var waves
var levelType

# variables for settings
var musicVol
var sfxVol
var fullscreen

func _ready():
	# _readLevelJson()
	_setSettings()

func _on_ExitLevelButton_pressed():
	pass

# all functions from this point on are for settings
func _on_SettingsButton_pressed():
	$Level/Settings.show()

func _on_SettingsButtonExit_pressed():
	$Level/Settings.hide()

func _setSettings():
	# read file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var data = file.get_as_text()
	data = JSON.parse(data)
	file.close()
	
	# read variables
	musicVol = int(data.result["settings"]["music"])
	sfxVol = int(data.result["settings"]["sfx"])
	fullscreen = data.result["settings"]["fullscreen"]
	
	# edit in-game settings
	$Level/Settings/Control/MusicVolume/MusicVolumeSlider/HSlider.value = musicVol
	$Level/Settings/Control/SFXVolume/SFXVolumeSlider/HSlider.value = sfxVol
	$Level/Settings/Control/Fullscreen/FullscreenTick/CheckBox.pressed = fullscreen

func _on_MusicVolume_changed(musicVolume):
	musicVolume = int(musicVolume)
	
	# change volume
	if musicVolume <= 100 && musicVolume > 80:
		pass
	elif musicVolume <= 80 && musicVolume > 60:
		pass
	elif musicVolume <= 60 && musicVolume > 40:
		pass
	elif musicVolume <= 40 && musicVolume > 20:
		pass
	elif musicVolume <= 20 && musicVolume > 0:
		pass
	elif musicVolume == 0:
		pass
	
	# open the save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var json_data = JSON.parse(file.get_as_text())
	file.close()
	var save_data = json_data.result
	
	# edit the save file
	save_data["settings"]["music"] = musicVolume
	var editedSave = File.new()
	editedSave.open("res://save_data.json", File.WRITE)
	editedSave.store_line(JSON.print(save_data))
	editedSave.close()

func _on_SFXVolume_changed(sfxVolume):
	sfxVolume = int(sfxVolume)
	
	# change volume
	if sfxVolume <= 100 && sfxVolume > 80:
		pass
	elif sfxVolume <= 80 && sfxVolume > 60:
		pass
	elif sfxVolume <= 60 && sfxVolume > 40:
		pass
	elif sfxVolume <= 40 && sfxVolume > 20:
		pass
	elif sfxVolume <= 20 && sfxVolume > 0:
		pass
	elif sfxVolume == 0:
		pass
	
	# open the save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var json_data = JSON.parse(file.get_as_text())
	file.close()
	var save_data = json_data.result
	
	# edit the save file
	save_data["settings"]["sfx"] = sfxVolume
	var editedSave = File.new()
	editedSave.open("res://save_data.json", File.WRITE)
	editedSave.store_line(JSON.print(save_data))
	editedSave.close()

func _on_Fullscreen_toggled(fullscreenPressed):
	if fullscreenPressed == true:
		OS.window_fullscreen = true
	elif fullscreenPressed == false:
		OS.window_fullscreen = false
		
	# open the save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var json_data = JSON.parse(file.get_as_text())
	file.close()
	var save_data = json_data.result
	
	# edit the save file
	save_data["settings"]["fullscreen"] = fullscreenPressed
	var editedSave = File.new()
	editedSave.open("res://save_data.json", File.WRITE)
	editedSave.store_line(JSON.print(save_data))
	editedSave.close()

func _readLevelJson():
	# read file
	var file = File.new()
	file.open(levelPath, File.READ)
	var data = file.get_as_text()
	data = JSON.parse(data)
	file.close()

	# load level metadata
	sun = int(data.result["ATWLevel"]["definition"]["startingSun"])
	stage = data.result["ATWLevel"]["definition"]["stage"]
	waves = int(data.result["ATWLevel"]["definition"]["waves"])
	levelType = data.result["ATWLevel"]["definition"]["type"]
