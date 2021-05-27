extends Node2D

var _dot_sprite
var level_ref
var _dot_transparency = 0.8
var _fade_out_timer 

func _ready():
	_fade_out_timer = $FadeOutTimer
	_fade_out_timer.autostart = true
	_fade_out_timer.one_shot = false
	level_ref = get_parent()
	_dot_sprite = $Sprite
	_dot_fade_in(0.025)

func _on_Area2D_body_entered(_body):
	#level_ref.dots_count -= 1
	pass

func _on_Area2D_body_exited(_body):
	_dot_fade_out(0.025)	
	queue_free()

func _dot_fade_in(fadeRate): #fades in 80% of sprite
	var currentAlpha = 0
	var times_to_iterate = 1 / fadeRate
	times_to_iterate *= _dot_transparency
	for x in times_to_iterate:
		yield(get_tree().create_timer(fadeRate / 2), "timeout")
		currentAlpha += fadeRate
		_dot_sprite.modulate = Color(255, 255, 255, currentAlpha)

func _dot_fade_out(fadeRate):
	var currentAlpha = _dot_sprite.modulate.a
	var times_to_iterate = 1 / fadeRate
	times_to_iterate *= _dot_transparency
	_fade_out_timer.wait_time = fadeRate / 2
	if self:
		for x in times_to_iterate:
			currentAlpha -= fadeRate
			_dot_sprite.modulate = Color(255, 255, 255, currentAlpha)
			yield(_fade_out_timer, "timeout")
			print(int(_fade_out_timer.time_left))

