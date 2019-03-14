extends Node2D

var type
var occupants = []

var MAX_OCCUPANTS = 4

func est_libre():
	return occupants.size()<MAX_OCCUPANTS

func ajout(occupant):
	if(est_libre()):
		occupants.append(occupant)
		var siege = "Siege"+String(occupants.size())
		if(siege=='Siege1'):
			occupant.debout_bas()
		elif(siege=='Siege2'):
			occupant.debout_droite()
		elif(siege=='Siege3'):
			occupant.debout_gauche()
		elif(siege=='Siege4'):
			occupant.debout_haut()
		occupant.set_pos(get_node(siege).get_pos()+Vector2(0,-10))
		self.add_child(occupant)
		
#func parler():
#	return occupants[randi()%occupants.size()].parler()
#	
#func questionner():
#	return occupants[randi()%occupants.size()].questionner()
	
func cartes():
	get_node("AnimationPlayer").play("Cartes")
	
func tension():
	var plateau = get_tree().get_root().get_node("Plateau")
	plateau.interface_couverture.tension()