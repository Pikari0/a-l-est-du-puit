extends Node2D

var ENTREE = load("res://Entree.tscn")
var PUIT = load("res://Puit.tscn")
var TOMBE = load("res://Tombe.tscn")
var HERBE = load("res://Herbe.tscn")

var nom
var batiments = []
var puits = []
var tombes = []
var entree

var bandit
var actions = []
var subtilite

var nb_saloons
var nb_cabinets_medecin
var nb_bureaux_sherif
var nb_tombes_cimetiere
var nb_entrepots
var nb_laboratoires_scientifique_fou
var nb_puits
var nb_commerces

var habitants = []
var hab_figurants = []
var hab_clefs = []
var hab_commeres = []
var hab_negociateurs = []


func affichage():
	print("ville nommée "+nom+" avec "+String(batiments.size())+" bâtiments")
	
func dessine():
	randomize()
	var tilemap = get_node("TileMap")
	for x in range(8000/32):
		for y in range(8000/32):
			var random_cell=randi()%4
			tilemap.set_cell(x,y,random_cell)
			
	var increment_pos = {'gauche':0,'droite':0}
	batiments.invert()
	for b in range(batiments.size()):
		batiments[b].dessine_enseigne()
		if randi()%2==0:
			batiments[b].set_pos(Vector2(1400,1000+increment_pos['gauche']))
			increment_pos['gauche']+=180+randi()%50
		else:
			batiments[b].set_pos(Vector2(1700,1000+increment_pos['droite']))
			increment_pos['droite']+=180+randi()%50
			batiments[b].miroir()				
		#batiments[b].geneFenetres()
		self.add_child(batiments[b])
	
	self.entree = ENTREE.instance()
	self.entree.nom_ville = self.nom
	self.entree.set_pos(Vector2(1550,900+max(increment_pos['gauche'],increment_pos['droite'])))
	self.add_child(self.entree)
		
	for p in range(self.nb_puits):
		var puit = PUIT.instance()
		var pos = self.batiments[randi()%self.batiments.size()].get_pos() * Vector2(0,1) + Vector2(rand_range(1500,1600),0)
		puit.set_pos(pos)
		self.add_child(puit)
		self.puits.append(puit)
	
	for h in range(10):
		var herbe = HERBE.instance()
		var pos = self.batiments[randi()%self.batiments.size()].get_pos() * Vector2(0,1) + Vector2(rand_range(1500,1600),0)
		herbe.set_pos(pos)
		self.add_child(herbe)
		
	var cote_carre = int(sqrt(self.nb_tombes_cimetiere))	
	for t in range(self.nb_tombes_cimetiere):
		var tombe = TOMBE.instance()
		tombe.set_pos(Vector2(1400+(randi()%cote_carre)*64,900-64*cote_carre+(randi()%cote_carre)*64))
		tombes.append(tombe)
		self.add_child(tombe)
		
#	self.add_child(self.bandit)
#	self.bandit.set_pos(self.entree.get_pos()+Vector2(-100,0))
