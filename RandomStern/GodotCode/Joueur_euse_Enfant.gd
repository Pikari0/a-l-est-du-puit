extends Node2D

var CLINT_ENFANT = load("res://clint_enfant.png")
var DOLORES_ENFANT = load("res://dolores_enfant.png")

var sexe = 1

func _ready():
	if(sexe):
		get_node("Sprite").set_texture(DOLORES_ENFANT)
	else:
		get_node("Sprite").set_texture(CLINT_ENFANT)
		
func marcher():
	var anim = get_node("AnimationPlayer")
	if(!anim.is_playing()):
		anim.play("marcher")
		
func mise_a_jour_sexe():
	if(sexe):
		get_node("Sprite").set_texture(DOLORES_ENFANT)
	else:
		get_node("Sprite").set_texture(CLINT_ENFANT)
