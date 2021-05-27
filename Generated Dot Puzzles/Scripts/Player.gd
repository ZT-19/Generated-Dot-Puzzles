extends Node2D

var ray
var current_swipe_direction
var spawn_dot
var clicked = false
var min_drag = 20 # To differentiate between tap and swipe
var grid_size = 32 #Not needed in player?
var dash_speed = 0.05
var screen_size # Currently not needed
var swipe_start: Vector2
var swipe_end: Vector2
var positions_list = Array()

func _ready():
	ray = $RayCast2D
	ray.cast_to = Vector2(50,0)
	ray.collide_with_areas = true
	ray.enabled = false
	#ray.collide_with_bodies = false
	
	screen_size = get_viewport().size

	positions_list.append(position)

func _process(_delta):
# Checking Ray collisions every frame is unecessary and bad for performance
# If performance is an issue then I can optimize this later
	if ray.is_colliding(): 
		ray.force_update_transform() # Possible Unecessary Update
		var dot_target = ray.get_collider().global_position
	# Tween Chunk: Works only if self position is global
		$Tween.interpolate_property(#Setting up tween animation
			self, "position", position, position + (dot_target - position),
			dash_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
		$Tween.start()
	#Tween Chunk End
		ray.enabled = false #DONT USE ray.enabled BOOL ANYWHERE ELSE
	"""elif !ray.is_colliding() and ray.enabled:
		var dot_target = current_swipe_direction * 100
	# Tween Chunk: Works only if self position is global
		$Tween.interpolate_property(#Setting up tween animation
			self, "position", position, position + (dot_target - position),
			dash_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
		$Tween.start()
	#Tween Chunk End
		ray.enabled = false"""

func _unhandled_input(event): #Possible null exception in detecting swipe vector
	if event is InputEventScreenDrag:
		if event.is_pressed():
			swipe_start = event.position
		if !event.is_pressed():
			swipe_end = event.relative
			current_swipe_direction = _convert_swipe_direction(swipe_start, swipe_end)
			_redirect_ray(current_swipe_direction)

func _convert_swipe_direction(_SwipeStart, _SwipeEnd):
	# Returns vert/horiz direction from swipe
	# Add a way to detect the size of swipe to not accidentally detect a tap
	var swipe = _SwipeEnd - _SwipeStart
	if max(abs(int(_SwipeEnd.x - _SwipeStart.x)), abs(int(_SwipeEnd.y - _SwipeStart.y))) > min_drag:# checks if drag is long enough, rewrite cuz ugly
	#print(swipe)
		if abs(swipe.x) > abs(swipe.y):
			if swipe.x > 0:
				return Vector2.RIGHT
			elif swipe.x < 0:
				return Vector2.LEFT
			else:
				return null
		elif abs(swipe.x) < abs(swipe.y):
			if swipe.y < 0:
				return Vector2.UP
			elif swipe.y > 0:
				return Vector2.DOWN
			else:
				return null
		else:
			return null
	else:
		return null

func _redirect_ray(dir):
	if dir == null:
		print("No Direction Received")
		return
#Actual Code for the dash
	else: 
		var vector_pos = dir * (grid_size * grid_size) # Need more precise value
		ray.cast_to = vector_pos
		ray.force_update_transform() # Possible Unecessary Update
		ray.enabled = true # Allow Process to start checking and move Player


func _on_VisibilityNotifier2D_screen_exited():# Connect to level to restart
	#position = positions_list[0]
	get_tree().reload_current_scene()
	#print("invis")
