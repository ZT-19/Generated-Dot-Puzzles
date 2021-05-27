extends Node2D

onready var screen_size = get_viewport_rect().size
var themes_list = Array()
var temp = 0
func _ready():
	randomize() # Maybe put this in main
	for eachTheme in self.get_children():
		themes_list.append(eachTheme)
		eachTheme.visible = false
		
func select_theme(themeIndex, prevThemeIndex):
	themes_list[themeIndex].visible = true
	themes_list[prevThemeIndex].visible = false
	
func random_theme_index():
	return randi() % self.get_child_count()


func _on_Main_next_theme():
	var old_temp = temp
	while temp == old_temp:
		temp = random_theme_index()
	select_theme(temp, old_temp)
	print("running")
