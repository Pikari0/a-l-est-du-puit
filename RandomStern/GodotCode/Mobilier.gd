extends StaticBody2D

var type

var occupants = []
var max_occupants

func table():
	get_node("Sprite").set_frame(0)
	self.type='table'
	self.max_occupants=4

func siege():
	get_node("Sprite").set_frame(1)
	self.type='siege'
	self.max_occupants=1

func poutre():
	get_node("Sprite").set_frame(2)
	self.type='poutre'
	self.max_occupants=1
	
func presentoir():
	get_node("Sprite").set_frame(3)
	self.type='poutre'
	self.max_occupants