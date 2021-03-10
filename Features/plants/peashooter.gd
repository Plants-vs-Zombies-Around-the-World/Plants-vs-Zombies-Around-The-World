extends KinematicBody2D

var health
var damageOutput

func _ready():
	health = 120
	damageOutput = 20
	
func _process(delta):
	if health == 0:
		print("oh. i'm die. thank you forever.")
