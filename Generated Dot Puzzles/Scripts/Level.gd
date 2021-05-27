extends Node2D

signal complete
export var dots_count = 0


func _ready():
	for typeDot in self.get_children():
		if typeDot.is_in_group("destroy_to_finish_lvl"):
			dots_count += 1
	
	
func _process(_delta):
	if dots_count == 0:
		emit_signal("complete")
		#print("Level Complete")
