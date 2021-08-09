extends KinematicBody2D

var health
var damageOutput

func _ready():
	$Rigger/AnimationPlayerIdle.play("default")
	health = 120
	damageOutput = 20
	
func _process(delta):
	if health == 0:
		print("oh. i'm die. thank you forever.")


func _on_BlinkTimer_timeout():
	$Rigger/AnimationPlayerBlink.play("blink")
