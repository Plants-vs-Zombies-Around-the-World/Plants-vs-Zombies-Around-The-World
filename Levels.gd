extends Area2D

var scrollable = false

func _process(delta):
	if scrollable == true:
		var velocity = Vector2()  # The player's movement vector.
		if Input.is_action_pressed("ui_right"):
			position.x -= 5
		if Input.is_action_pressed("ui_left"):
			position.x += 5
			
		position.x = clamp(position.x, -3600, 0)
