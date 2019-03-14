extends Node2D

var INTERIEUR = load("res://Interieur.tscn")

var TABLE_SALOON = load("res://Table_Saloon.tscn")
var COMPTOIR_SALOON = load("res://Comptoir_Saloon.tscn")
var TONNEAU = load("res://Tonneau.tscn")
var MOBILIER = load("res://Mobilier.tscn")
var PRESENTOIR = load("res://Presentoir.tscn")

var TAILLE_CASE = 64

var nom
var residents = []
var type
var interieur = null

var mobilier = []

var deja_dessine = false

var bandit = null

func affichage():
	print(type+" nommé "+nom+" avec "+String(residents.size())+" résidents")

func mirroir():
	self.set_scale(Vector2(-1,1))
	
func dessine_enseigne():
	var enseigne = get_node("Enseigne")	
	if(self.type=="saloon"):
		enseigne.set_frame(0)
	elif(self.type=="cabinet_medecin"):
		enseigne.set_frame(1)
	elif(self.type=="bureau_sherif"):
		enseigne.set_frame(2)
	elif(self.type=="entrepot"):
		enseigne.set_frame(3)
	elif(self.type=="commerce"):
		enseigne.set_frame(4)
	elif(self.type=="laboratoire_scientifique_fou"):
		enseigne.set_frame(5)
	else:
		enseigne.set_frame(6)
	
func dessine():
	if(!deja_dessine):
		deja_dessine=true
		self.interieur = INTERIEUR.instance()
		if(self.type=="saloon"):
			self.interieur.largeur=TAILLE_CASE*8
			self.interieur.longueur=TAILLE_CASE*10
		elif(self.type=="entrepot"):
			self.interieur.largeur=TAILLE_CASE*4
			self.interieur.longueur=TAILLE_CASE*4
			var nb_tonneaux = randi()%4+2
			for t in range(nb_tonneaux):
				var tonneau = TONNEAU.instance()
				#tonneau.set_pos(Vector2(randi()%interieur.longueur,randi()%interieur.largeur))
				self.mobilier.append(tonneau)
				self.interieur.ajout(tonneau)
		elif(self.type=="commerce"):
			self.interieur.largeur=TAILLE_CASE*6
			self.interieur.longueur=TAILLE_CASE*8
			var nb_presentoirs = randi()%4+4
			for p in range(nb_presentoirs):
				var presentoir = PRESENTOIR.instance()
				#presentoir.set_pos(Vector2(randi()%interieur.longueur,randi()%interieur.largeur))
				self.mobilier.append(presentoir)
				self.interieur.ajout(presentoir)
		else:
			self.interieur.largeur=TAILLE_CASE*8
			self.interieur.longueur=TAILLE_CASE*8
		self.interieur.dessine()
		for res in residents:
			if(res.role=="joueur_de_cartes" || res.role=="client_a_table"):
				var table
				for meuble in mobilier:
					if('Table_Saloon' in meuble.get_name()):
						if(meuble.est_libre() && res.role==meuble.type):
							table=meuble
				if(table==null):
					table=TABLE_SALOON.instance()
					table.type=res.role
					table.MAX_OCCUPANTS = 2 + randi()%3
					self.interieur.ajout(table,1)
					self.mobilier.append(table)
				table.ajout(res)
				if(res.role=="joueur_de_cartes"):
					table.cartes()
			elif(res.role=="tavernier"):
				var comptoir = COMPTOIR_SALOON.instance()
				comptoir.set_pos(Vector2(randi()%(interieur.longueur-300)+100,48))
				comptoir.ajout(res)
				self.interieur.force_ajout(comptoir)
				self.mobilier.append(comptoir)
			else:
				#res.set_pos(Vector2(randi()%interieur.longueur,randi()%interieur.largeur))
				res.orienter_aleatoirement()
				if(self.type=="saloon"):
					if(randi()%3):
						var poutre = MOBILIER.instance()
						poutre.poutre()
						self.interieur.ajout(poutre,1)
						poutre.add_child(res)
						res.set_global_pos(poutre.get_pos()+Vector2(10,10))
					else:	
						self.interieur.ajout(res,1)
				else:
					self.interieur.ajout(res)
			
#			if(self.bandit!=null):
#				self.interieur.ajout(self.bandit)
#				self.bandit.orienter_aleatoirement()
			
func efface_pnj():
	for res in residents:
		self.interieur.remove_child(res)
		
func parler():
	return self.nom
	
#func geneFenetres():
#	var frame_fenetre = randi()%4
#	var fenetres = get_node("Fenetres")
#	for fenetre in fenetres.get_children():
#		fenetre.set_frame(frame_fenetre)
#	
#	var frame_reflet = randi()%4
#	var reflets = get_node("Reflets")
#	for reflet in reflets.get_children():
#		reflet.set_frame(frame_reflet)