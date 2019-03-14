extends Node2D

signal fin_selection

var sexe_selectionne

func _ready():
	set_process(true)

func _process(delta):
	if(Input.is_action_pressed("gauche")):
		get_node("Homme").set_scale(Vector2(6,6))
		get_node("Femme").set_scale(Vector2(4,4))
		self.sexe_selectionne=0
	elif(Input.is_action_pressed("droite")):
		get_node("Femme").set_scale(Vector2(6,6))
		get_node("Homme").set_scale(Vector2(4,4))
		self.sexe_selectionne=1
	elif(Input.is_action_pressed("action")):
		self.emit_signal("fin_selection",self.sexe_selectionne)