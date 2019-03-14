extends Node2D

var SEUIL = load("res://Seuil.tscn")

var largeur
var longueur

var pas_de_la_porte

var TAILLE_CASE = 64
var cases_prises = []

func dessine():
	var tilemap = get_node("Sol_Interieur")	
	for x in range(longueur/32):
		for y in range(largeur/32):
			var random_cell=randi()%4
			tilemap.set_cell(x,y,random_cell)
	
	for x in range((longueur+64)/32):
		# tuiles néant
		tilemap.set_cell(x-1,largeur/32,6)
		tilemap.set_cell(x-1,-1,6)
	for y in range((largeur+64)/32):
		# tuiles néant
		tilemap.set_cell(longueur/32,y-1,6)
		tilemap.set_cell(-1,y-1,6)
	
	
	pas_de_la_porte=Vector2(longueur/2,largeur+10)
	var seuil = SEUIL.instance()
	seuil.set_pos(pas_de_la_porte)
	self.add_child(seuil)
	
	
	# degager l'entrée
	var pos_bandit_decouvert = self.pas_de_la_porte#+Vector2(5,-100)
	var case_x = pos_bandit_decouvert.x/TAILLE_CASE
	var case_y = pos_bandit_decouvert.y/TAILLE_CASE
	var pos = Vector2(int(case_x),int(case_y))
	self.cases_prises.append(pos)
	for x in range(1):
		for y in range(2):
#			var test = SEUIL.instance()
#			test.set_global_pos((pos+Vector2(-x,-y))*TAILLE_CASE)
#			self.add_child(test)
			self.cases_prises.append(pos+Vector2(-x,-y))
	
	print(self.cases_prises)
	#tilemap.set_cell(pas_de_la_porte.x/32,pas_de_la_porte.y/32,5)
	
#func ajout(objet):
#	print(objet.get_item_and_children_rect().size)
#	var pos_correcte = false
#	var pos_potentielle 
#	while !pos_correcte:
#		pos_potentielle = Vector2(randi()%self.longueur,randi()%(self.largeur-148)+148)
#		pos_correcte = true
#		for enfant in self.get_children():
#			if !("Sol_Interieur" in enfant.get_name()):
#				var distance_a = objet.get_pos().distance_to(enfant.get_pos())
#				#print(distance_a)
#				var min_distance = max(objet.get_item_and_children_rect().size.x,objet.get_item_and_children_rect().size.y)
#				print(min_distance)
#				if(distance_a< min_distance):
#					pos_correcte = false
#	
#	objet.set_pos(pos_potentielle)
#	self.add_child(objet)

# nouvelle fonction d'ajout, basée par cases
func ajout(objet,MARGE=1):
	var nb_cases_largeur = self.largeur/TAILLE_CASE
	var nb_cases_longeur = self.longueur/TAILLE_CASE
	var nb_cases = nb_cases_largeur*nb_cases_longeur
	
	if(self.cases_prises.size()<nb_cases):
		var potentielle_case = Vector2(randi()%(nb_cases_longeur-MARGE)+MARGE,randi()%(nb_cases_largeur-MARGE)+MARGE)
#		while(potentielle_case in self.cases_prises):
#			potentielle_case = Vector2(nb_cases_longeur,nb_cases_largeur)
		
		if !(potentielle_case in self.cases_prises):
			objet.set_pos(potentielle_case * Vector2(TAILLE_CASE,TAILLE_CASE))
			self.add_child(objet)
			self.cases_prises.append(potentielle_case)
		else:
			self.ajout(objet,MARGE)
	else:
		print("Plus de cases libres !")

func force_ajout(objet):
	var case_x = objet.get_pos().x/TAILLE_CASE
	var case_y = objet.get_pos().y/TAILLE_CASE
	var pos = Vector2(int(case_x),int(case_y))
	var taille_en_case_x = (objet.get_item_and_children_rect().size/TAILLE_CASE).x+1
	var taille_en_case_y = (objet.get_item_and_children_rect().size/TAILLE_CASE).y+1
	for i in range(taille_en_case_x):
		for j in range(taille_en_case_y):
			self.cases_prises.append(pos+Vector2(i,j))
	self.add_child(objet)
