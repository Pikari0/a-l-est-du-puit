extends Control

var ville
var action_courante
var indicateurs = []
var indice_courant
var batiment_bandit = null

var icone_bandit

var nb_questionner = 0

func _ready():
	icone_bandit=get_node("Icone_Bandit")
	set_fixed_process(true)
	
func _fixed_process(delta):
	var etape_courante = int(self.icone_bandit.get_pos().x/32)
	if(etape_courante<self.indicateurs.size()-1):
		self.icone_bandit.move(Vector2(delta/2,0))
		self.progression(int(self.icone_bandit.get_pos().x/32))

func geneVisuel(ville):
	self.ville=ville
	var nb_etapes = ville.actions.size()
	self.show()
	var modele = get_node("Sprite")
	indicateurs.append(modele)
	#étapes non finales
	for i in range(1,nb_etapes-1):
		var indicateur = modele.duplicate()
		indicateur.set_pos(modele.get_pos()+Vector2(i*32,0))
		indicateur.set_frame(1)
		indicateurs.append(indicateur)
		self.add_child(indicateur)
	#étape finale
	var indicateur = modele.duplicate()
	indicateur.set_pos(modele.get_pos()+Vector2((nb_etapes-1)*32-12,0))
	indicateur.set_frame(2)
	indicateurs.append(indicateur)
	self.add_child(indicateur)
	
	indice_courant = 0
	action_courante = ville.actions[indice_courant]
	
	self.placement_bandit()

func progression(indice_bandit):
	if(indice_bandit>indice_courant):
		indice_courant+=1
		#print(indice_courant)
		if(indice_courant<indicateurs.size()-1):
	#		var indicateur = indicateurs[indice_courant]
	#		indicateur.set_frame(indicateur.get_frame()-1)
	#		action_courante = ville.actions[indice_courant]
			self.placement_bandit()
			get_tree().get_root().get_node("Plateau").lecteur_musique.play("Cloche")
		else:
			get_tree().get_root().get_node("Plateau").decouvert()
	
func placement_bandit():
	if(self.batiment_bandit!=null):
		self.batiment_bandit.bandit=null
		if(self.batiment_bandit.interieur!=null):
			self.batiment_bandit.interieur.remove_child(self.ville.bandit)
	var batiments_potentiels = []
	for batiment in self.ville.batiments:
		if(batiment.type==action_courante[1]):
			batiments_potentiels.append(batiment)
		
	self.batiment_bandit = batiments_potentiels[randi()%batiments_potentiels.size()]
	self.batiment_bandit.bandit=ville.bandit
	if(self.batiment_bandit.interieur != null):
		self.batiment_bandit.interieur.ajout(ville.bandit)
	
func reinitialiser():
	self.icone_bandit.set_pos(Vector2(0,0))

#func increment_questionner():
#	nb_questionner+=1
#	if(nb_questionner>=3):
#		self.progression()
#		nb_questionner=0
		