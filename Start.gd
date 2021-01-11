extends Node2D

var playPressable = true
var settingsPressable = true
var exitPressable = true
var profilePressable = true
var playerName
var profileNum
var file
var data
var json_data
var save_data

func _ready():
	# make most of the buttons unpressable
	playPressable = false
	settingsPressable = false
	exitPressable = false
	profilePressable = false
	
	# get the save file
	file = File.new()
	file.open("res://save_data.json", File.READ)
	data = file.get_as_text()
	json_data = JSON.parse(data)
	file.close()
	save_data = json_data.result["data"]
	profileNum = int(json_data.result["profileNum"])
	
	if save_data.count(null) == 5:
		# if the save file is empty, open the prompt that will allow for creation of a new profile
		$NewProfileMaker.show()
		$NewProfileMaker/Control/ProfileMakerExit.hide()
	else:
		# when a save file is filled up, collect stuff about the last chosen profile
		playerName = save_data[profileNum]["name"]
		print(profileNum)
		$ChangeProfile/ProfileName/Label.text = playerName
		
		# fill up all the available profile names
		for n in range(5):
			if n < save_data.size() - save_data.count(null):
				# for available profiles
				get_node("ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = save_data[n]["name"]
			else:
				# for unavailable profiles
				get_node("ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").disabled = true
		
		# make buttons pressable again
		playPressable = true
		settingsPressable = true
		exitPressable = true
		profilePressable = true

func _on_Start_Button_pressed():
	if playPressable == true:
		print("playin le game")

func _on_Settings_Button_pressed():
	if settingsPressable == true:
		$Settings.show()
		exitPressable = false
		playPressable = false
		profilePressable = false

func _on_Exit_Button_pressed():
	if exitPressable == true:
		$ExitConfirmation.show()
		settingsPressable = false
		playPressable = false
		profilePressable = false

func _on_SettingsExitButton_pressed():
	$Settings.hide()
	exitPressable = true
	playPressable = true
	profilePressable = true

func _on_ExitNoButton_pressed():
	$ExitConfirmation.hide()
	settingsPressable = true
	playPressable = true
	profilePressable = true

func _on_ExitYesButton_pressed():
	get_tree().quit()

func _on_CreditsButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Credits/Credits.tscn")

func _on_DiscordButton_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://discord.gg/NnhXQgEqSp")

func _on_ProfileButton_pressed():
	if profilePressable == true:
		$ProfilePanel.show()
		settingsPressable = false
		playPressable = false
		exitPressable = false

func _on_ProfileExitButton_pressed():
	$ProfilePanel.hide()
	$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
	$ProfilePanel/Control/ProfileMaxWarning/Label.text = ""
	settingsPressable = true
	playPressable = true
	exitPressable = true

func _on_ExitProfileMakerButton_pressed():
	$NewProfileMaker.hide()
	playPressable = true
	settingsPressable = true
	exitPressable = true
	profilePressable = true

func _on_MakeProfileButton_pressed():
	# this is for when a profile has been created
	playerName = $NewProfileMaker/Control/ProfileMakerInput.get_text()
	if playerName.length() > 0:
		# read save file
		file.open("res://save_data.json", File.READ)
		json_data = JSON.parse(file.get_as_text())
		file.close()
		save_data = json_data.result
		
		# do stuff for save file
		save_data["profileNum"] = save_data["data"].size()-save_data["data"].count(null)
		save_data["data"][save_data["data"].size()-save_data["data"].count(null)] = {"name": playerName}
		
		#overwrite save file
		var editedSave = File.new()
		editedSave.open("res://save_data.json", File.WRITE)
		editedSave.store_line(JSON.print(save_data))
		editedSave.close()
		
		# change stuff to accomodate for the changed profile
		$ChangeProfile/ProfileName/Label.text = playerName
		get_node("ProfilePanel/Control/ProfileList/Profile"+str(profileNum)+"/Button").text = save_data["data"][profileNum]["name"]
		profileNum = save_data["profileNum"]
		
		# update profile list when new profile is made
		for n in range(5):
			if n < save_data["data"].size() - save_data["data"].count(null):
				# for available profiles
				get_node("ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").text = save_data["data"][n]["name"]
				get_node("ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").disabled = false
			else:
				# for unavailable profiles
				get_node("ProfilePanel/Control/ProfileList/Profile"+str(n)+"/Button").disabled = true
		
		# exit and make buttons pressable again
		playPressable = true
		settingsPressable = true
		exitPressable = true
		profilePressable = true
		$NewProfileMaker.hide()
		$NewProfileMaker/Control/ProfileMakerWarning/Label.text = ""
	else:
		$NewProfileMaker/Control/ProfileMakerWarning/Label.text = "Name cannot be blank"

func _on_ProfileZeroButton_toggled(button_pressed):
	if button_pressed == true:
		$ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		
		$ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$ProfilePanel/Control/ProfileEdit/Button.disabled = false
		
		if profileNum != 0:
			$ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$ProfilePanel/Control/ProfileEdit/Button.disabled = true

func _on_ProfileOneButton_toggled(button_pressed):
	if button_pressed == true:
		$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		
		$ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$ProfilePanel/Control/ProfileEdit/Button.disabled = false
		
		if profileNum != 1:
			$ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$ProfilePanel/Control/ProfileEdit/Button.disabled = true


func _on_ProfileTwoButton_toggled(button_pressed):
	if button_pressed == true:
		$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		
		$ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$ProfilePanel/Control/ProfileEdit/Button.disabled = false
		
		if profileNum != 2:
			$ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$ProfilePanel/Control/ProfileEdit/Button.disabled = true

func _on_ProfileThreeButton_toggled(button_pressed):
	if button_pressed == true:
		$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		
		$ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$ProfilePanel/Control/ProfileEdit/Button.disabled = false
		
		if profileNum != 3:
			$ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		print("goodbye")
		$ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$ProfilePanel/Control/ProfileEdit/Button.disabled = true

func _on_ProfileFourButton_toggled(button_pressed):
	if button_pressed == true:
		$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
		$ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
		
		$ProfilePanel/Control/ProfileCreate/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = false
		$ProfilePanel/Control/ProfileEdit/Button.disabled = false
	
		if profileNum != 4:
			$ProfilePanel/Control/ProfileSwitch/Button.disabled = false
	else:
		$ProfilePanel/Control/ProfileCreate/Button.disabled = false
		$ProfilePanel/Control/ProfileSwitch/Button.disabled = true
		$ProfilePanel/Control/ProfileDelete/Button.disabled = true
		$ProfilePanel/Control/ProfileEdit/Button.disabled = true

func _on_CreateProfileButton_pressed():
		file = File.new()
		file.open("res://save_data.json", File.READ)
		json_data = JSON.parse(file.get_as_text())
		file.close()
		save_data = json_data.result
		$NewProfileMaker/Control/ProfileMakerExit.show()
		
		if save_data["data"].count(null) != 0:
			$NewProfileMaker/Control/ProfileMakerInput.text = ""
			$NewProfileMaker.show()
		else:
			$ProfilePanel/Control/ProfileMaxWarning/Label.text = "Maximum amount of profiles reached! You can only have up to 5 profiles!"

func _onProfileSwitchButton_pressed():
	file = File.new()
	file.open("res://save_data.json", File.READ)
	json_data = JSON.parse(file.get_as_text())
	file.close()
	save_data = json_data.result
	
	var editedSave
	
	match profileNum:
		0:
			if $ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
				print("from zero to one")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][1]["name"]
				profileNum = 1
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
				print("from zero to two")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][2]["name"]
				profileNum = 2
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
				print("from zero to three")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][3]["name"]
				profileNum = 3
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
				print("from zero to four")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][4]["name"]
				profileNum = 4
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		1:
			if $ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
				print("from one to zero")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][0]["name"]
				profileNum = 0
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
				print("from one to two")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][2]["name"]
				profileNum = 2
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
				print("from one to three")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][3]["name"]
				profileNum = 3
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
				print("from one to four")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][4]["name"]
				profileNum = 4
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		2:
			if $ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
				print("from two to zero")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][0]["name"]
				profileNum = 0
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
				print("from two to one")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][1]["name"]
				profileNum = 1
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
				print("from two to three")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][3]["name"]
				profileNum = 3
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
				print("from two to four")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][4]["name"]
				profileNum = 4
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		3:
			if $ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
				print("from three to zero")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][0]["name"]
				profileNum = 0
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
				print("from three to one")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][1]["name"]
				profileNum = 1
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
				print("from three to two")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][2]["name"]
				profileNum = 2
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile4/Button.pressed == true:
				print("from three to four")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][4]["name"]
				profileNum = 4
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile4/Button.pressed = false
		4:
			if $ProfilePanel/Control/ProfileList/Profile0/Button.pressed == true:
				print("from four to zero")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][0]["name"]
				profileNum = 0
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile0/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile1/Button.pressed == true:
				print("from four to one")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][1]["name"]
				profileNum = 1
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile1/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile2/Button.pressed == true:
				print("from four to two")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][2]["name"]
				profileNum = 2
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile2/Button.pressed = false
			if $ProfilePanel/Control/ProfileList/Profile3/Button.pressed == true:
				print("from four to three")
				# update ingame stuff
				$ChangeProfile/ProfileName/Label.text = save_data["data"][3]["name"]
				profileNum = 3
				
				# overwrite save data
				save_data["profileNum"] = profileNum
				editedSave = File.new()
				editedSave.open("res://save_data.json", File.WRITE)
				editedSave.store_line(JSON.print(save_data))
				editedSave.close()
				
				#exit the panel
				$ProfilePanel.hide()
				$ProfilePanel/Control/ProfileList/Profile3/Button.pressed = false
