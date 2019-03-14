extends KinematicBody2D

signal fin

var increment = Vector2(0,0)

var collision = false
var lanceur = null

var VITESSE = 10

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if(!self.collision && self.get_global_pos().distance_to(self.lanceur.get_global_pos())>1000):
		emit_signal("fin")
		self.queue_free()
	if(self.is_colliding()):
		var collider = self.get_collider()
		if(collider!=self.lanceur):
			if(collider.has_method("mourir")):
				collider.mourir()
			if(collider.has_method("tension")):
				collider.tension()
			self.collision = true
			emit_signal("fin")
			self.queue_free()
	self.move(self.incrementer())

func definir_lanceur(lanceur):
	self.lanceur=lanceur

func diriger(vecteur):
	self.increment = vecteur

func incrementer():
	return self.increment*Vector2(VITESSE,VITESSE)
