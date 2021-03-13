extends Node2D

var profileNum

var plantText
var plantName
var plantStats

var zombieText
var zombieName
var zombieStats

func _ready():
	# get the save file
	var fileSave = File.new()
	fileSave.open("res://save_data.json", File.READ)
	var saveData = fileSave.get_as_text()
	saveData = JSON.parse(saveData)
	fileSave.close()
	
	# get the almanac file
	var fileAlmanac = File.new()
	fileAlmanac.open("res://Almanac/almanac.json", File.READ)
	var almanacData = fileAlmanac.get_as_text()
	almanacData = JSON.parse(almanacData)
	fileAlmanac.close()
	
	# update list of plants in the almanac
	for n in almanacData.result["plants"].size():
		pass
		
	# update almanac text when you click on something
	
