extends KinematicBody2D

var chrono = 0

func _ready():
	set_process(true)
	print(self.get_pos())

func _process(delta):
	if(chrono>1):
		self.move_to(self.fonction(self.get_pos()))
		print(self.get_pos())
		chrono=0
	chrono+=delta
	
func fonction(vecteur):
	var x=vecteur.x
	var y=vecteur.y
	x+=1
	y = -abs(100 * cos(2*3.14*x+0.8))
	return Vector2(Vector2(x,y))