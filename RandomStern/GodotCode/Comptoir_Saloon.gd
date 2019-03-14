extends Node2D
var tavernier

func ajout(tavernier):
	self.tavernier=tavernier
	tavernier.set_pos(get_node("Tavernier_Pos").get_pos())
	self.add_child(tavernier)
	tavernier.orienter_aleatoirement()
	
func parler():
	return tavernier.parler()
	
func questionner():
	return tavernier.questionner()
	
func tension():
	var plateau = get_tree().get_root().get_node("Plateau")
	plateau.interface_couverture.tension()
	
func se_retourner(pos_joueur):
	self.tavernier.orienter_aleatoirement()