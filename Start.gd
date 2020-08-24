extends Node2D

var playPressable = true
var settingsPressable = true
var exitPressable = true
var profilePressable = true
var playerName
var profileNum

func _ready():
	# make most of the buttons unpressable
	playPressable = false
	settingsPressable = false
	exitPressable = false
	profilePressable = false
	
	# get the save file
	var file = File.new()
	file.open("res://save_data.json", File.READ)
	var data = file.get_as_text()
	var json_data = JSON.parse(data)
	file.close()
	var save_data = json_data.result["data"]
	var profileNum = json_data.result["profileNum"]
	if save_data.size() <= 0:
		# if the save file is empty, open the prompt that will allow for creation of a new profile
		$NewProfileMaker.show()
		$NewProfileMaker/Control/ProfileMakerExit.hide()
	else:
		# when a save file is filled up, collect stuff about the last chosen profile
		playerName = save_data[profileNum]["name"]
		$ChangeProfile/ProfileName/Label.text = playerName
		
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
	OS.shell_open("https://discord.gg/bP6sAky")

func _on_ProfileButton_pressed():
	if profilePressable == true:
		$ProfilePanel.show()
		settingsPressable = false
		playPressable = false
		exitPressable = false

func _on_ProfileExitButton_pressed():
	$ProfilePanel.hide()
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
		var save = File.new()
		save.open("res://save_data.json", File.READ)
		var save_json = JSON.parse(save.get_as_text())
		save.close()
		var save_data = save_json.result
		
		# do stuff for save file
		save_data["data"] = [{"name": playerName}]
		
		#overwrite save file
		var editedSave = File.new()
		editedSave.open("res://save_data.json", File.WRITE)
		editedSave.store_line(JSON.print(save_data))
		editedSave.close()
		
		# change stuff to accomodate for the changed profile
		$ChangeProfile/ProfileName/Label.text = playerName
		
		# exit and make buttons pressable again
		playPressable = true
		settingsPressable = true
		exitPressable = true
		profilePressable = true
		$NewProfileMaker.hide()
	else:
		$NewProfileMaker/Control/ProfileMakerWarning/Label.text = "Name cannot be blank"
