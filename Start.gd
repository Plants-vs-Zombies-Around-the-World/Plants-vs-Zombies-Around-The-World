extends Node2D


var playPressable = true
var settingsPressable = true
var exitPressable = true
var profilePressable = true
var profileMakerPressable = true
var playerName
var profileNum
var isSaving = true
var pressedButton
var musicVol
var sfxVol
var fullscreen
var mainMenuLevelsPressable = true
var settingsLevelsPressable = true

func _ready():
	$Music.playing = true
	$MainMenu.show()
	$Credits.hide()
	$LevelBrowser.hide()
	_onMakeFirstProfile()

func _onMakeFirstProfile():
	# make most of the buttons unpressable
	playPressable = false
	settingsPressable = false
	exitPressable = false
	profilePressable = false
	
	# check if there is a save file, if there's none, make it
	var newReadFile = File.new()
	newReadFile.open("res://save_data.json", File.READ)
	if newReadFile.file_exists("res://save_data.json") == false:
		print("file doesnt exist")
		
		var newCreateFile = File.new()
		newCreateFile.open("res://save_data.json", File.WRITE)
		newCreateFile.store_string("{\"profileNum\":0, \"settings\": {\"music\": 100, \"sfx\": 100, \"fullscreen\": true}, \"data\":[null,null,null,null,null]}")
		newCreateFile.close()
		newReadFile.close()
	else:
		print("file exists")
		newReadFile.close()
	
	# get the save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var data = file.get_as_text()
	var json_data = JSON.parse(data)
	file.close()
	var save_data = json_data.result["data"]
	profileNum = int(json_data.result["profileNum"])
	musicVol = json_data.result["settings"]["music"]
	sfxVol = json_data.result["settings"]["sfx"]
	fullscreen = json_data.result["settings"]["fullscreen"]
	
	if save_data.count(null) == 5:
		# if the save file is empty, open the prompt that will allow for creation of a new profile
		$MainMenu/NewProfileMaker.show()
		$MainMenu/NewProfileMaker/Control/ProfileMakerExit.hide()
	else:
		# when a save file is filled up, collect stuff about the last chosen profile
		playerName = save_data[profileNum]["name"]
		print(profileNum)
		$MainMenu/ChangeProfile/ProfileName/Label.text = playerName
		
		# fill up all the available profile names
		for n in range(5):
			if n < save_data.size() - save_data.count(null):
				# for available profiles
				get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = save_data[n]["name"]
			else:
				# for unavailable profiles
				get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").disabled = true
		
		# make buttons pressable again
		playPressable = true
		settingsPressable = true
		exitPressable = true
		profilePressable = true
		
		# edit in-game settings
		$MainMenu/Settings/Control/MusicVolume/MusicVolumeSlider/HSlider.value = musicVol
		$MainMenu/Settings/Control/SFXVolume/SFXVolumeSlider/HSlider.value = sfxVol
		$MainMenu/Settings/Control/Fullscreen/FullscreenTick/CheckBox.pressed = fullscreen

# all functions from this point on are for vital settings functions
func _on_MusicVolume_changed(musicVolume):
	musicVolume = int(musicVolume)
	
	# change volume
	if musicVolume <= 100 && musicVolume > 80:
		$Music.stream_paused = false
		$Music.volume_db = 0
	elif musicVolume <= 80 && musicVolume > 60:
		$Music.stream_paused = false
		$Music.volume_db = -10
	elif musicVolume <= 60 && musicVolume > 40:
		$Music.stream_paused = false
		$Music.volume_db = -20
	elif musicVolume <= 40 && musicVolume > 20:
		$Music.stream_paused = false
		$Music.volume_db = -30
	elif musicVolume <= 20 && musicVolume > 0:
		$Music.stream_paused = false
		$Music.volume_db = -40
	elif musicVolume == 0:
		$Music.stream_paused = true
	
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
		$ButtonSFX1.stream_paused = false
		$ButtonSFX2.stream_paused = false
		$ButtonSFX1.volume_db = 0
		$ButtonSFX2.volume_db = 0
	elif sfxVolume <= 80 && sfxVolume > 60:
		$ButtonSFX1.stream_paused = false
		$ButtonSFX2.stream_paused = false
		$ButtonSFX1.volume_db = -10
		$ButtonSFX2.volume_db = -10
	elif sfxVolume <= 60 && sfxVolume > 40:
		$ButtonSFX1.stream_paused = false
		$ButtonSFX2.stream_paused = false
		$ButtonSFX1.volume_db = -20
		$ButtonSFX2.volume_db = -20
	elif sfxVolume <= 40 && sfxVolume > 20:
		$ButtonSFX1.stream_paused = false
		$ButtonSFX2.stream_paused = false
		$ButtonSFX1.volume_db = -30
		$ButtonSFX2.volume_db = -30
	elif sfxVolume <= 20 && sfxVolume > 0:
		$ButtonSFX1.stream_paused = false
		$ButtonSFX2.stream_paused = false
		$ButtonSFX1.volume_db = -40
		$ButtonSFX1.volume_db = -40
	elif sfxVolume == 0:
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

# all functions from this point on are for the main menu
func _on_EnterMainMenu_():
	# get the save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var data = file.get_as_text()
	var json_data = JSON.parse(data)
	file.close()
	musicVol = json_data.result["settings"]["music"]
	sfxVol = json_data.result["settings"]["sfx"]
	fullscreen = json_data.result["settings"]["fullscreen"]
	
	# change settings here too
	$MainMenu/Settings/Control/MusicVolume/MusicVolumeSlider/HSlider.value = musicVol
	$MainMenu/Settings/Control/SFXVolume/SFXVolumeSlider/HSlider.value = sfxVol
	$MainMenu/Settings/Control/Fullscreen/FullscreenTick/CheckBox.pressed = fullscreen
	
func _on_Start_Button_pressed():
	if playPressable == true:
		$ButtonSFX1.play()
		$LevelBrowser.show()
		$MainMenu.hide()

func _on_Settings_Button_pressed():
	if settingsPressable == true:
		$ButtonSFX1.play()
		$MainMenu/Settings.show()
		settingsPressable = false
		exitPressable = false
		playPressable = false
		profilePressable = false

func _on_Exit_Button_pressed():
	if exitPressable == true:
		$ButtonSFX1.play()
		$MainMenu/ExitConfirmation.show()
		exitPressable = false
		settingsPressable = false
		playPressable = false
		profilePressable = false

func _on_SettingsExitButton_pressed():
	$ButtonSFX2.play()
	$MainMenu/Settings.hide()
	settingsPressable = true
	exitPressable = true
	playPressable = true
	profilePressable = true

func _on_ExitNoButton_pressed():
	$ButtonSFX2.play()
	$MainMenu/ExitConfirmation.hide()
	exitPressable = true
	settingsPressable = true
	playPressable = true
	profilePressable = true

func _on_ExitYesButton_pressed():
	$ButtonSFX2.play()
	get_tree().quit()

func _on_CreditsButton_pressed():
	$ButtonSFX1.play()
	$MainMenu.hide()
	$MainMenu/Settings.hide()
	$Credits.show()

func _on_DiscordButton_pressed():
	$ButtonSFX1.play()
	# warning-ignore:return_value_discarded
	OS.shell_open("https://discord.gg/NnhXQgEqSp")

func _on_ProfileButton_pressed():
	if profilePressable == true:
		$ButtonSFX1.play()
		$MainMenu/ProfilePanel.show()
		profilePressable = false
		settingsPressable = false
		playPressable = false
		exitPressable = false

func _on_ProfileExitButton_pressed():
	if profileMakerPressable == true:
		$ButtonSFX2.play()
		$MainMenu/ProfilePanel.hide()
		$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileMaxWarning/Label.text = ""
		profilePressable = true
		settingsPressable = true
		playPressable = true
		exitPressable = true

func _on_ExitProfileMakerButton_pressed():
	$MainMenu/NewProfileMaker.hide()
	playPressable = true
	settingsPressable = true
	exitPressable = true
	profilePressable = true
	isSaving = false
	
	$MainMenu/NewProfileMaker/Control/ProfileMakerWarning/Label.text = ""
	profileMakerPressable = true

func _on_MakeProfileButton_pressed():
	# read save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var json_data = JSON.parse(file.get_as_text())
	file.close()
	var save_data = json_data.result
	
	playerName = $MainMenu/NewProfileMaker/Control/ProfileMakerInput.get_text()
	if isSaving == true: # this is for when a profile has been created
			if playerName.length() > 0:
				# do stuff for save file
				save_data["profileNum"] = save_data["data"].size()-save_data["data"].count(null)
				save_data["data"][save_data["data"].size()-save_data["data"].count(null)] = {"name": playerName}
				
				#overwrite save file
				var editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				# change stuff to accomodate for the changed profile
				$MainMenu/ChangeProfile/ProfileName/Label.text = playerName
				get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(profileNum)+"/Button").text = save_data["data"][profileNum]["name"]
				profileNum = save_data["profileNum"]
				
				# update profile list when new profile is made
				for n in range(5):
					if n < save_data["data"].size() - save_data["data"].count(null):
						# for available profiles
						get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = save_data["data"][n]["name"]
						get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").disabled = false
					else:
						# for unavailable profiles
						get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").disabled = true
					
				# exit and make buttons pressable again
				playPressable = true
				settingsPressable = true
				exitPressable = true
				profilePressable = true
				$MainMenu/NewProfileMaker.hide()
				$MainMenu/NewProfileMaker/Control/ProfileMakerWarning/Label.text = ""
			else:
				$MainMenu/NewProfileMaker/Control/ProfileMakerWarning/Label.text = "Name cannot be blank"
	elif isSaving == false: # this is for when a profile is edited
		playerName = $MainMenu/NewProfileMaker/Control/ProfileMakerInput.text
		if playerName.length() > 0:
			save_data["data"][pressedButton]["name"] = playerName
			
			#overwrite save file
			var editedSave = File.new()
			editedSave.open("res://save_data.json", File.WRITE)
			editedSave.store_line(JSON.print(save_data))
			editedSave.close()
			
			# change stuff to accomodate for the changed profile
			get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(pressedButton)+"/Button").text = save_data["data"][pressedButton]["name"]
			
			for _n in range(5):
				if profileNum == pressedButton:
					$MainMenu/ChangeProfile/ProfileName/Label.text = playerName
					get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(profileNum)+"/Button").text = save_data["data"][profileNum]["name"]
					profileNum = save_data["profileNum"]
					break
			
			$MainMenu/NewProfileMaker.hide()
			$MainMenu/NewProfileMaker/Control/ProfileMakerWarning/Label.text = ""
			isSaving = true
		else:
			$MainMenu/NewProfileMaker/Control/ProfileMakerWarning/Label.text = "Name cannot be blank"
	
	$MainMenu/NewProfileMaker/Control/ProfileMakerInput.text = ""
	profileMakerPressable = true
	
func _on_ProfileZeroButton_toggled(button_pressed):
	if button_pressed == true:
		$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = false
		
		if profileNum != 0:
			$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = true

func _on_ProfileOneButton_toggled(button_pressed):
	if button_pressed == true:
		$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = false
		
		if profileNum != 1:
			$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = true


func _on_ProfileTwoButton_toggled(button_pressed):
	if button_pressed == true:
		$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = false
		
		if profileNum != 2:
			$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = true

func _on_ProfileThreeButton_toggled(button_pressed):
	if button_pressed == true:
		$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = false
		
		if profileNum != 3:
			$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = true

func _on_ProfileFourButton_toggled(button_pressed):
	if button_pressed == true:
		$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
		$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
		
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = false
	
		if profileNum != 4:
			$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$MainMenu/ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$MainMenu/ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$MainMenu/ProfilePanel/Control/ProfileEdit/Button.disabled = true

func _on_CreateProfileButton_pressed():
	profileMakerPressable = false
	isSaving = true
	$MainMenu/NewProfileMaker/Control/ProfileMakerHeader/Label.text = "Enter Your Name"
	$MainMenu/NewProfileMaker/Control/MakeProfile.text = "Create Profile"
	
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var json_data = JSON.parse(file.get_as_text())
	file.close()
	var save_data = json_data.result
	
	if save_data["data"].count(null) != 0:
		$MainMenu/NewProfileMaker.show()
	else:
		$MainMenu/ProfilePanel/Control/ProfileMaxWarning/Label.text = "Maximum amount of profiles reached! You can only have up to 5 profiles!"
	
	$MainMenu/NewProfileMaker/Control/ProfileMakerExit.show()

func _onProfileSwitchButton_pressed():
	profileMakerPressable = false
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var json_data = JSON.parse(file.get_as_text())
	file.close()
	var save_data = json_data.result
	
	var editedSave
	
	match profileNum:
		0:
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][1]["name"]
				profileNum = 1
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][2]["name"]
				profileNum = 2
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][3]["name"]
				profileNum = 3
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][4]["name"]
				profileNum = 4
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		1:
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][0]["name"]
				profileNum = 0
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][2]["name"]
				profileNum = 2
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][3]["name"]
				profileNum = 3
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][4]["name"]
				profileNum = 4
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		2:
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][0]["name"]
				profileNum = 0
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][1]["name"]
				profileNum = 1
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][3]["name"]
				profileNum = 3
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][4]["name"]
				profileNum = 4
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		3:
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][0]["name"]
				profileNum = 0
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][1]["name"]
				profileNum = 1
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][2]["name"]
				profileNum = 2
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][4]["name"]
				profileNum = 4
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		4:
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][0]["name"]
				profileNum = 0
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][1]["name"]
				profileNum = 1
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][2]["name"]
				profileNum = 2
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
			if $MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
				# update ingame stuff
				$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][3]["name"]
				profileNum = 3
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$MainMenu/ProfilePanel.hide()
				$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false

func _on_ProfileEditButton_pressed():
	profileMakerPressable = false
	isSaving = false
	
	$MainMenu/NewProfileMaker/Control/ProfileMakerHeader/Label.text = "Edit Name"
	$MainMenu/NewProfileMaker/Control/MakeProfile.text = "Change Profile"
	
	#see what button got pressed
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
		pressedButton = 0
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
		pressedButton = 1
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
		pressedButton = 2
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
		pressedButton = 3
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
		pressedButton = 4
	
	# unpress all profiles
	$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
	$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
	$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
	$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
	$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
	
	$MainMenu/NewProfileMaker.show()
	$MainMenu/NewProfileMaker/Control/ProfileMakerExit.show()

func _on_ProfileDeleteButton_pressed():
	profileMakerPressable = false
	
	#see what button got pressed
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
		pressedButton = 0
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
		pressedButton = 1
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
		pressedButton = 2
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
		pressedButton = 3
	if $MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
		pressedButton = 4
	
	# unpress all profiles
	$MainMenu/ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
	$MainMenu/ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
	$MainMenu/ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
	$MainMenu/ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
	$MainMenu/ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
	
	$MainMenu/DeleteConfirmation.show()
	$MainMenu/ProfilePanel.hide()

func _on_DeleteProfileNoButton_pressed():
	$MainMenu/DeleteConfirmation.hide()
	$MainMenu/ProfilePanel.show()
	profileMakerPressable = true

func _on_DeleteProfileYesButton_pressed():
	# read save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var json_data = JSON.parse(file.get_as_text())
	file.close()
	var save_data = json_data.result
	
	# edit save file and extract stuff from it
	print(pressedButton)
	save_data["data"][pressedButton] = null
	save_data["data"].sort_custom(customProfileSorter, "sort")
	profileNum = save_data["profileNum"]
	print("delete")
	print(profileNum)
	print(save_data["data"][pressedButton])
	
	if save_data["data"][profileNum] == null && (save_data["data"].size() - save_data["data"].count(null)) > 0: # do stuff normally if there are some profiles left
		print("many profiles left")
		profileNum -= 1
		save_data["profileNum"] = profileNum
		
		# update profile list when new profile is made
		for n in range(5):
			if n < save_data["data"].size() - save_data["data"].count(null):
				# for available profiles
				get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = save_data["data"][n]["name"]
				get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").disabled = false
			else:
				# for unavailable profiles
				get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").disabled = true
				match n:
					0:
						get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = "(Player One)"
					1:
						get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = "(Player Two)"
					2:
						get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = "(Player Three)"
					3:
						get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = "(Player Four)"
					4:
						get_node("MainMenu/ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = "(Player Five)"
		$MainMenu/ChangeProfile/ProfileName/Label.text = save_data["data"][profileNum]["name"]
		
		# overwrite save file
		var editedSave = File.new()
		editedSave.open("res://save_data.json", File.WRITE)
		editedSave.store_line(JSON.print(save_data))
		editedSave.close()
		
		# finishing touches
		$MainMenu/DeleteConfirmation.hide()
		$MainMenu/ProfilePanel.show()
	elif save_data["data"][profileNum] == null && (save_data["data"].size() - save_data["data"].count(null)) == 0: # if there are no profiles left make a new one
		print("no profiles left")
		
		# overwrite save file
		var editedSave = File.new()
		editedSave.open("res://save_data.json", File.WRITE)
		editedSave.store_line(JSON.print(save_data))
		editedSave.close()
		
		$MainMenu/DeleteConfirmation.hide()
		$MainMenu/ProfilePanel.hide()
		_onMakeFirstProfile()
	
class customProfileSorter: # this is for sorting profiles after one gets deleted
	static func sort(a, b):
		if a != null && b == null:
			return true
		return false

# all functions from this point on are for the credits
func _on_ReturnToMainMenuFromCreditsButton_pressed():
	$ButtonSFX2.play()
	$MainMenu.show()
	$MainMenu/Settings.show()
	$Credits.hide()

# all functions from this point on are for the level browser
func _on_EnterLevelBrowser_():
	# get the save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var data = file.get_as_text()
	var json_data = JSON.parse(data)
	file.close()
	musicVol = json_data.result["settings"]["music"]
	sfxVol = json_data.result["settings"]["sfx"]
	fullscreen = json_data.result["settings"]["fullscreen"]
	
	# change settings here too
	$LevelBrowser/Settings/Control/MusicVolume/MusicVolumeSlider/HSlider.value = musicVol
	$LevelBrowser/Settings/Control/SFXVolume/SFXVolumeSlider/HSlider.value = sfxVol
	$LevelBrowser/Settings/Control/Fullscreen/FullscreenTick/CheckBox.pressed = fullscreen

func _on_MainMenuFromLevels_pressed():
	if mainMenuLevelsPressable == true:
		$ButtonSFX2.play()
		$MainMenu.show()
		$LevelBrowser.hide()

func _on_SettingsButtonFromLevels_pressed():
	if settingsLevelsPressable == true:
		$ButtonSFX1.play()
		mainMenuLevelsPressable = false
		settingsLevelsPressable = false
		$LevelBrowser/Settings.show()

func _on_ExitSettingsFromLevels_pressed():
	$ButtonSFX2.play()
	$LevelBrowser/Settings.hide()
	mainMenuLevelsPressable = true
	settingsLevelsPressable = true

func loadtest():
	var file = File.new()
	file.open("levelpath", File.WRITE)
	file.store_string("Levels/SuburbiaLevel1.json")
	file.close()
	get_tree().change_scene("res://LevelRunner/LevelRunner.tscn")
