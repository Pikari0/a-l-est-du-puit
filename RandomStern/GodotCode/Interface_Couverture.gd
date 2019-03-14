extends Control

const DECREMENT = 0.5

var couverture = 100
var barre

func _ready():
	barre = get_node("TextureProgress")
	barre.set_value(self.couverture)

func diminuer():
	self.couverture -= DECREMENT
	barre.set_value(self.couverture)
	if(self.couverture < 0):
		get_tree().get_root().get_node("Plateau").decouvert()
		
func interrogatoire():
	for i in range(8):
		self.diminuer()
		
func tension():
	var plateau = get_tree().get_root().get_node("Plateau")
	plateau.lecteur_musique.stop_all()
	var residents = plateau.batiment.residents
	var joueur_euse = plateau.joueur_euse
	for resident in residents:
		if resident.acteur!="figurant":
			resident.goutte(true)
		if(resident.get_global_pos().x>joueur_euse.get_pos().x):
			resident.debout_gauche()
		elif(resident.get_global_pos().x<joueur_euse.get_pos().x):
			resident.debout_droite()
		else:
			if(resident.get_global_pos().y<joueur_euse.get_pos().y):
				resident.debout_haut()
			elif(resident.get_global_pos().y>joueur_euse.get_pos().y):
				resident.debout_bas()
	self.couverture -= 40
	barre.set_value(self.couverture)
	if(self.couverture < 0):
		get_tree().get_root().get_node("Plateau").decouvert()
		
func reinitialiser():
	self.couverture=100
	barre.set_value(self.couverture)