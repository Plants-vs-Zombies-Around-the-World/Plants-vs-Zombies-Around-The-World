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
	# read file
	var file = File.new()
	file.open("levelpath", File.READ)
	levelPath = "res://Levels/"+file.get_as_text()
	file.close()
	print(levelPath)
	
	_setSettings()
	_readLevelJson()

func _on_ExitLevelButton_pressed():
	$Level/LeaveConfirmation.show()
	$Level/Settings.hide()
	$ButtonSFX2.play()

func _on_ExitLevelConfirmYes_pressed():
	get_tree().change_scene("res://Start.tscn")
	
func _on_ExitLevelConfirmNo_pressed():
	$Level/Settings.show()
	$Level/LeaveConfirmation.hide()
	$ButtonSFX1.play()

# all functions from this point on are for settings
func _on_SettingsButton_pressed():
	$Level/Settings.show()
	$PauseEffect.play()

func _on_SettingsButtonExit_pressed():
	$Level/Settings.hide()
	$ButtonSFX2.play()

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
		$PauseEffect.volume_db = -10
		$PauseEffect.stream_paused = false
		
		$ButtonSFX1.volume_db = 0
		$ButtonSFX1.stream_paused = false
		
		$ButtonSFX2.volume_db = 0
		$ButtonSFX2.stream_paused = false
	elif sfxVolume <= 80 && sfxVolume > 60:
		$PauseEffect.volume_db = -20
		$PauseEffect.stream_paused = false
		
		$ButtonSFX1.volume_db = -10
		$ButtonSFX1.stream_paused = false
		
		$ButtonSFX2.volume_db = -10
		$ButtonSFX2.stream_paused = false
	elif sfxVolume <= 60 && sfxVolume > 40:
		$PauseEffect.volume_db = -30
		$PauseEffect.stream_paused = false
		
		$ButtonSFX1.volume_db = -20
		$ButtonSFX1.stream_paused = false
		
		$ButtonSFX2.volume_db = -20
		$ButtonSFX2.stream_paused = false
	elif sfxVolume <= 40 && sfxVolume > 20:
		$PauseEffect.volume_db = -40
		$PauseEffect.stream_paused = false
		
		$ButtonSFX1.volume_db = -30
		$ButtonSFX1.stream_paused = false
		
		$ButtonSFX2.volume_db = -30
		$ButtonSFX2.stream_paused = false
	elif sfxVolume <= 20 && sfxVolume > 0:
		$PauseEffect.volume_db = -50
		$PauseEffect.stream_paused = false
		
		$ButtonSFX1.volume_db = -40
		$ButtonSFX1.stream_paused = false
		
		$ButtonSFX2.volume_db = -40
		$ButtonSFX2.stream_paused = false
	elif sfxVolume == 0:
		$PauseEffect.stream_paused = true
		$ButtonSFX1.stream_paused = true
		$ButtonSFX2.stream_paused = true
	
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
	
	print(sun)
	print(stage)
