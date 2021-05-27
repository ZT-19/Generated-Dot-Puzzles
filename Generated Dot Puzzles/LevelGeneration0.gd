extends Node2D

enum offsets{X = 96, Y = 320}
var grid_size = 32
var grid_side_length = 13
var blank_grid = [
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
]

func _ready():
	#print(_draw_grid(5, _generate_init_pos_axis(), _generate_init_pos_axis()))
	_draw_grid(10, _generate_rand_pos_axis(), _generate_rand_pos_axis())

func _draw_grid(difficultyRating, init_x, init_y):
	# Use _generate_init_pos_axis for random position for init_x and init_y
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var difficulty_range = 1
	var random_difficulty = rng.randi_range(difficultyRating - difficulty_range, difficultyRating + difficulty_range)
	var temp_grid = blank_grid
	temp_grid[init_x][init_y] = 1
	var current_x = init_x
	var current_y = init_y
	#Direction variables
	var current_direction = rng.randi_range(0, 3) # Initiate for safety
	var prev_direction = current_direction #Initiate for safety
	
	#Spawns player at init pos
	var player_resource = load("res://Scenes/Player.tscn")
	var player_instance = player_resource.instance()
	self.add_child(player_instance)
	player_instance.position = _middle_of_grid(current_x, current_y)
	#Spawns player

	while(difficultyRating > 0): #change to use random difficulty
		#Note: I don't have anything for corner cases yet
		#Edgecases Below
		if current_x == 0:#If stuck on left edge: Go up or down, then right
			var up_or_down = rng.randi_range(0, 1)
			match up_or_down:
				0:#Going up
					var findY = rng.randi_range(current_y + 1, grid_side_length - 1)
					current_y = findY
					temp_grid[current_x][findY] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
				1:#Going Down
					var findY = rng.randi_range(0, current_y - 1)
					current_y = findY
					temp_grid[current_x][findY] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
			#Going right
			var findX = rng.randi_range(current_x + 1, grid_side_length - 1)
			current_x = findX
			temp_grid[current_x][current_y] = 1
			#Loads dot at new coordinate
			_generate_dot(current_x, current_y)
			difficultyRating -= 2# Subtract two moves
			#Change above^ code to only run if there's more than two moves left
			#Which allows for final dots to be on edges or corners

		elif current_x == grid_side_length - 1:#If stuck on right edge: Go up or down, then left
			var up_or_down = rng.randi_range(0, 1)
			match up_or_down:
				0:#Going up
					var findY = rng.randi_range(current_y + 1, grid_side_length - 1)
					current_y = findY
					temp_grid[current_x][findY] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
				1:#Going Down
					var findY = rng.randi_range(0, current_y - 1)
					current_y = findY
					temp_grid[current_x][findY] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
			#Going left
			var findX = rng.randi_range(0, current_x - 1)
			current_x = findX
			temp_grid[findX][current_y] = 1
			#Loads dot at new coordinate
			_generate_dot(current_x, current_y)
			difficultyRating -= 2# Subtract two moves
			#Change above^ code to only run if there's more than two moves left
			#Which allows for final dots to be on edges or corners

		elif current_y == 0:#If stuck on top ledge: Go left or right, then down
			var up_or_down = rng.randi_range(0, 1)
			match up_or_down:
				0:#Going left
					#Finds random x coordinate
					#Current_x - 1 makes sure we dont spawn on same point
					var findX = rng.randi_range(0, current_x - 1)
					current_x = findX
					temp_grid[findX][current_y] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
				1:#Going right
					#Finds random x coordinate
					#Current_x + 1 makes sure we dont spawn on same point
					var findX = rng.randi_range(current_x + 1, grid_side_length - 1)
					current_x = findX
					temp_grid[current_x][current_y] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
			#Going Down
			#Finds random y coordinate
			#Current_y + 1 makes sure we dont spawn on same point
			var findY = rng.randi_range(current_y + 1, grid_side_length - 1)
			current_y = findY
			temp_grid[current_x][findY] = 1
			#Loads dot at new coordinate
			_generate_dot(current_x, current_y)
			difficultyRating -= 2# Subtract two moves
			#Change above^ code to only run if there's more than two moves left
			#Which allows for final dots to be on edges or corners

		elif current_y == grid_side_length - 1:#If stuck on bottom ledge: Go left or right, then up
			var up_or_down = rng.randi_range(0, 1)
			match up_or_down:
				0:#Going left
					#Finds random x coordinate
					#Current_x - 1 makes sure we dont spawn on same point
					var findX = rng.randi_range(0, current_x - 1)
					current_x = findX
					temp_grid[findX][current_y] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
				1:#Going right
					#Finds random x coordinate
					#Current_x + 1 makes sure we dont spawn on same point
					var findX = rng.randi_range(current_x + 1, grid_side_length - 1)
					current_x = findX
					temp_grid[current_x][current_y] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
			#Going up
			#Finds random y coordinate
			#Current_y - 1 1 makes sure we dont spawn on same point
			var findY = rng.randi_range(0, current_y - 1)
			current_y = findY
			temp_grid[current_x][findY] = 1
			#Loads dot at new coordinate
			_generate_dot(current_x, current_y)
			difficultyRating -= 2# Subtract two moves
			#Change above^ code to only run if there's more than two moves left
			#Which allows for final dots to be on edges or corners

		#Edgecases Above
		
		else: #If no edge cases or corner cases
			#Find Direction
			current_direction = rng.randi_range(0, 3)
			prev_direction = current_direction
			
			match current_direction:
				0: #Going Right
					#Finds random x coordinate
					#Current_x + 1 makes sure we dont spawn on same point
					var findX = rng.randi_range(current_x + 1, grid_side_length - 1)
					current_x = findX
					temp_grid[current_x][current_y] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
					
				1: #Going Left
					#Finds random x coordinate
					#Current_x - 1 makes sure we dont spawn on same point
					var findX = rng.randi_range(0, current_x - 1)
					current_x = findX
					temp_grid[findX][current_y] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
				
				2: #Going down
					#Finds random y coordinate
					#Current_y + 1 makes sure we dont spawn on same point
					var findY = rng.randi_range(current_y + 1, grid_side_length - 1)
					current_y = findY
					temp_grid[current_x][findY] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
					
				3: #Going up
					#Finds random y coordinate
					#Current_y - 1 1 makes sure we dont spawn on same point
					var findY = rng.randi_range(0, current_y - 1)
					current_y = findY
					temp_grid[current_x][findY] = 1
					#Loads dot at new coordinate
					_generate_dot(current_x, current_y)
			difficultyRating -= 1
	return temp_grid

func _middle_of_grid(changeThisX, changeThisY):
	return Vector2(((changeThisX+1) * grid_size) + offsets.X, ((changeThisY+1) * grid_size) + offsets.Y)

func _generate_rand_pos_axis():
	randomize()
	return randi() % grid_side_length

func _generate_dot(dotX, dotY):
	var dot_resource = load("res://Scenes/Dot.tscn")
	var dot_instance = dot_resource.instance()
	self.add_child(dot_instance)
	dot_instance.position = _middle_of_grid(dotX, dotY)


#Old Code Idk
"""
		while current_direction == prev_direction:
			if current_x == 0 or current_x == grid_side_length - 1:
				current_direction = rng.randi_range(2, 3)
			elif current_y == 0 or current_y == grid_side_length - 1:
				current_direction = rng.randi_range(0, 1)
			else:
				current_direction = rng.randi_range(0,3) #Choose direction
"""
"""
		var select_axis = rng.randi_range(0, 1)
		if select_axis:# If select axis is 1, go in the y direction
			
		#Finds random y coordinate
			var findX = _generate_rand_pos_axis()
			while findX == current_x:#Make sure that we dont spawn on same point
				findX = _generate_rand_pos_axis()
			temp_grid[findX][current_y] = 1
			current_x = findX
		#Finds random y coordinate
		
		#Loads dot at new coordinate
			_generate_dot(current_x, current_y)
		
		else: # If select axis is 0, go in the x direction
		
		#Finds random x coordinate
			var findY = _generate_rand_pos_axis()
			while findY == current_y:#Make sure that we dont spawn on same point
				findY = _generate_rand_pos_axis()
			temp_grid[current_x][findY] = 1
			current_y = findY
		#Finds random x coordinate
		
		#Loads dot at new coordinate
			_generate_dot(current_x, current_y)
"""
