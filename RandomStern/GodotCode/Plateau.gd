extends Control

var INTRODUCTION = load("res://Introduction.tscn")
var SELECTION_SEXE = load("res://Selection_Sexe.tscn")
var DIDACTICIEL = load("res://Didacticiel.tscn")
var GAMEOVER = load("GameOver.tscn")
var GAMEUP = load("GameUp.tscn")

var JOUEUR_EUSE = load("res://Joueur_euse.tscn")
var BALLE = load("res://Balle.tscn")
var PIECE = load("res://Piece.tscn")
var VENT = load("res://Vent.tscn")
var FUMEE = load("res://Fumee.tscn")

var ville
var batiment = null
var joueur_euse = null
var balle_joueur = null
var balle_bandit = null

var position_precedente
var decouvert = false

var introduction
var bullogue
var interface_pistolet
var interface_progression_intrigue
var interface_couverture
var selection_sexe = null
var didacticiel = null
var gameover = null
var gameup = null
var piece = null

const DECALAGE_DUEL = 10

var shader_intimider
var shader_coucher_soleil
var shader_ralenti
var shader_reve

var lecteur_musique
var volume_musique=0
var debut_musique = false
var fin_musique = false

var duel = false
var sexe = 0

func _ready():
	bullogue=get_node("Bullogue")
	interface_pistolet=get_node("CanvasLayer/Interface_Pistolet")
	interface_progression_intrigue=get_node("CanvasLayer/Interface_Progression_Intrigue")
	interface_couverture=get_node("CanvasLayer/Interface_Couverture")
	
	self.selection_sexe()
	
	shader_intimider = get_node("CanvasLayer/Intimider")
	shader_coucher_soleil = get_node("CanvasLayer/Coucher_Soleil")
	shader_ralenti = get_node("CanvasLayer/Ralenti")
	shader_reve = get_node("CanvasLayer/Reve")
	
	lecteur_musique = get_node("SamplePlayer2D")
	
	set_fixed_process(true)

func cacher_interface():
	interface_pistolet.hide()
	interface_progression_intrigue.hide()
	interface_couverture.hide()
	
func selection_sexe():
	self.cacher_interface()
	
	self.selection_sexe=SELECTION_SEXE.instance()
	self.add_child(self.selection_sexe)
	
	self.selection_sexe.connect("fin_selection",self,"lancement")
	
func didacticiel():
	self.didacticiel=DIDACTICIEL.instance()
	self.didacticiel.sexe=self.sexe
	self.add_child(self.didacticiel)
	self.batiment=self.didacticiel
	self.didacticiel.connect("reveil",self,"introduction")

func lancement(sexe):
	self.selection_sexe.disconnect("fin_selection",self,"lancement")
	self.selection_sexe.queue_free()
	self.selection_sexe=null
	
	self.sexe = sexe

	self.didacticiel()

func introduction():
	self.joueur_euse = JOUEUR_EUSE.instance()
	self.joueur_euse.sexe = self.sexe
	
	self.duel=false
	self.lecteur_musique.play("Vent",0)
	self.batiment=null
	self.shader_coucher_soleil.hide()
	self.shader_reve.hide()
	if(self.gameover!=null):
		self.remove_child(self.gameover)
		#self.gameover.queue_free()
		self.gameover=null
	if(self.gameup!=null):
		self.remove_child(self.gameup)
		#self.gameup.queue_free()
		self.gameup=null
	if(self.didacticiel!=null):
		self.remove_child(self.didacticiel)
		#self.didacticiel.queue_free()
		self.didacticiel=null
	self.cacher_interface()
	
	var glados=get_node("GlaDOS")
	self.ville=glados.gene()
	
	self.introduction = INTRODUCTION.instance()
	self.introduction.sexe = self.joueur_euse.sexe
	self.add_child(self.introduction)
	self.introduction.change_nom_bandit(self.ville.bandit.qualificatif)
	self.introduction.connect("fin_intro",self,"aventure",[],CONNECT_ONESHOT)
	self.affiche_noeuds_fils()

func affiche_noeuds_fils():
	print("--")
	for fils in self.get_children():
		print(fils.get_name())
	print("--")

func aventure():
	self.interface_progression_intrigue.reinitialiser()
	self.interface_couverture.reinitialiser()
	
	if(self.introduction!=null):
		self.remove_child(self.introduction)
		#self.didacticiel.queue_free()
		self.introduction=null
		
	self.affiche_noeuds_fils()
	self.lecteur_musique.stop_all()
#	self.remove_child(self.introduction)
	
	interface_pistolet.show()
	interface_progression_intrigue.show()
	interface_couverture.show()
	
	interface_couverture.reinitialiser()

	
	self.add_child(ville)
	self.ville.dessine()
	self.ville.add_child(self.joueur_euse)
	self.joueur_euse.show()
	self.joueur_euse.set_pos(ville.entree.get_pos()+Vector2(0,50))
	self.joueur_euse.debout_haut()
	self.joueur_euse.devient_controllable(true)
	self.interface_progression_intrigue.geneVisuel(self.ville)
	
	self.lecteur_musique.play("Vent",0)
	
#	Input.action_press("dégaine_pistolet")
#	Input.action_press("charge_pistolet")
#	Input.action_release("charge_pistolet")
#	Input.action_release("dégaine_pistolet")
#	Input.action_press("rengaine_pistolet")
#	Input.action_release("rengaine_pistolet")
	
func interieur(batiment):
	self.lecteur_musique.stop_all()
	self.bullogue.force_fin()
	# on s'occupe du joueur
	self.ville.remove_child(self.joueur_euse)
	self.position_precedente=self.joueur_euse.get_pos()
	# puis du décors
	self.remove_child(ville)
	
	self.batiment=batiment
	self.batiment.dessine()
	self.add_child(batiment.interieur)
	
	# on s'occupe du bandit
	if(self.batiment.bandit != null):
		self.batiment.interieur.ajout(self.batiment.bandit)
		self.batiment.bandit.orienter_aleatoirement()
	
	self.joueur_euse.set_pos(batiment.interieur.pas_de_la_porte+Vector2(0,-32))
	self.joueur_euse.devient_controllable(true)
	self.batiment.interieur.add_child(self.joueur_euse)
	
	if(decouvert):
		var interface_progression_intrigue = self.interface_progression_intrigue
		self.batiment.interieur.ajout(self.ville.bandit)
		self.ville.bandit.tir_bas()
		self.ville.bandit.set_pos(self.batiment.interieur.pas_de_la_porte+Vector2(5,-100))
		self.bullogue.ecrire("Ahah, bien essayé mais tu n'iras pas plus loin dans ton enquête.",self.ville.bandit)
		self.bullogue.connect("fin_replique",self,"tir_bandit",[],CONNECT_ONESHOT)
		self.joueur_euse.duel(true)
		self.joueur_euse.debout_haut()
	
	if(batiment.type=="saloon"):
		self.lecteur_musique.play("Saloon"+str(randi()%2+1),0)
	
func exterieur():
	self.lecteur_musique.play("Vent",0)
	# on s'occupe du joueur
	self.batiment.interieur.remove_child(self.joueur_euse)
	# puis du décors
	self.remove_child(self.batiment.interieur)
	# on s'occupe du bandit
	if(self.batiment != null):
		self.batiment.interieur.remove_child(self.batiment.bandit)
	self.batiment=null
	
	self.add_child(self.ville)
	
	self.joueur_euse.set_pos(self.position_precedente)
	self.ville.add_child(self.joueur_euse)
	
func duel_final():
	print("duel final")
	self.duel = true
	#self.lecteur_musique.play("Duel")
	self.exterieur()
	self.interface_couverture.hide()
	self.interface_progression_intrigue.hide()

	self.joueur_euse.duel(true)
	self.joueur_euse.set_pos(Vector2(400-DECALAGE_DUEL/3,400))
	self.joueur_euse.debout_haut()
	self.ville.bandit.set_pos(Vector2(400+DECALAGE_DUEL/3,300))
	self.ville.bandit.debout_bas()
	
#	self.camera.set_pos(Vector2(200,200))
#	self.camera.make_current() 
	
	self.ville.add_child(self.ville.bandit)
	self.bullogue.ecrire(self.ville.bandit.monologuer(),self.ville.bandit)
	self.bullogue.connect("fin_replique", self,"piece_tombe",[],CONNECT_ONESHOT)

func piece_tombe():
	self.piece = PIECE.instance()
	self.piece.set_pos(Vector2(551,475))
	self.piece.set_scale(Vector2(2,2))
	self.add_child(self.piece)
	self.piece.connect("piece_au_sol",self,"tir_bandit",[],CONNECT_ONESHOT)
	self.piece.connect("piece_au_sol",self.shader_ralenti,"show",[],CONNECT_ONESHOT)

func tir_bandit():
	self.tir(self.ville.bandit)

func decouvert():
	self.decouvert = true

func gameover():
	self.lecteur_musique.stop_all()

	self.shader_ralenti.hide()
	self.cacher_interface()
	self.fin_de_ville()
	
	self.joueur_euse.duel(false)
	self.gameover = GAMEOVER.instance()
	self.gameover.sexe = self.joueur_euse.sexe
	self.add_child(self.gameover)
	self.gameover.connect("nouveau_depart",self,"introduction")
#	var camera = Camera2D.new()
#	var label = Label.new()
#	label.set_text("GAME OVER")
#	label.add_font_override("font",load("res://ubuntu_test.fnt"))
#	
#	var tombe = self.ville.tombes[randi()%self.ville.tombes.size()]
#	
#	tombe.add_child(camera)
#	camera.make_current()
#	camera.set_zoom(Vector2(0.25,0.25))
#	
#	tombe.add_child(label)
#	label.set_pos(Vector2(-35,-35))

func gameup():
	self.bullogue.force_fin()
	self.shader_ralenti.hide()
	self.cacher_interface()
	self.fin_de_ville()
	
	self.joueur_euse.duel(false)
	self.gameup = GAMEUP.instance()
	self.gameup.sexe = self.joueur_euse.sexe
	self.add_child(self.gameup)
	self.gameup.connect("nouveau_depart",self,"introduction")

	#self.introduction()

func fin_de_ville():
	print("Fin de la ville !")
	self.bullogue.force_fin()
	
	self.shader_intimider.hide()
	self.shader_ralenti.hide()
	self.decouvert=false
	self.remove_child(self.ville)
	self.ville.remove_child(self.joueur_euse)         
	self.ville.queue_free()
	self.ville=null
	if(self.batiment!=null):
		self.remove_child(self.batiment.interieur)
		self.batiment.interieur.remove_child(self.joueur_euse)
	if(self.balle_joueur!=null):
		self.balle_joueur.queue_free()
		self.balle_joueur=null
	if(self.balle_bandit!=null):
		self.balle_bandit.queue_free()
		self.balle_bandit=null

	if(self.piece!=null):
		print("Suppression de la pièce qui tombe.")
		self.piece.disconnect("piece_au_sol",self,"tir_bandit")
		self.piece.disconnect("piece_au_sol",self.shader_ralenti,"show")
		self.piece.queue_free()
		self.piece=null
	else:
		print("Suppression du déclencheur de la pièce qui tombe.")
		self.bullogue.disconnect("fin_replique", self,"piece_tombe")
		
	if(self.interface_progression_intrigue.batiment_bandit!=null):
		self.interface_progression_intrigue.batiment_bandit=null	
	self.interface_progression_intrigue.reinitialiser()
	self.interface_couverture.reinitialiser()

func tir(tireur):
	var vecteur_direction
	if("haut" in tireur.anim_courante):
		vecteur_direction=Vector2(0,-1)
	elif("bas" in tireur.anim_courante):
		vecteur_direction=Vector2(0,1)
	elif("gauche" in tireur.anim_courante):
		vecteur_direction=Vector2(-1,0)
	elif("droite" in tireur.anim_courante):
		vecteur_direction=Vector2(1,0)
	
	if(tireur.get_name()=="Joueur_euse" && balle_joueur==null):
		if(duel):
			tir_bandit()
		self.balle_joueur = BALLE.instance()
		self.balle_joueur.diriger(vecteur_direction)
		self.balle_joueur.definir_lanceur(tireur)
		self.balle_joueur.set_pos(tireur.get_pos()+vecteur_direction*Vector2(DECALAGE_DUEL,DECALAGE_DUEL))
		self.add_child(self.balle_joueur)
		self.balle_joueur.connect("fin",self,"fin_balle",[self.balle_bandit,"joueur"],CONNECT_ONESHOT)
	if(tireur.get_name()=="Bandit" && balle_bandit==null):
		tireur.lecteur_musique.play("Tir")
		self.balle_bandit = BALLE.instance()
		self.balle_bandit.diriger(vecteur_direction)
		self.balle_bandit.definir_lanceur(tireur)
		self.balle_bandit.set_pos(tireur.get_pos()+vecteur_direction*Vector2(-DECALAGE_DUEL,DECALAGE_DUEL))
		self.add_child(self.balle_bandit)
		self.balle_bandit.connect("fin",self,"fin_balle",[self.balle_bandit,"bandit"],CONNECT_ONESHOT)

func fin_balle(balle,proprietaire):
	self.remove_child(balle)
	#balle.queue_free()
	if(proprietaire=="joueur"):
		self.balle_joueur=null
	else:
		self.balle_bandit=null

func _fixed_process(delta):
	if(self.joueur_euse!=null):
		if(randi()%100==0):
			if(self.batiment == null):
				var vent = VENT.instance()
				vent.set_pos(self.joueur_euse.get_pos()+Vector2(rand_range(-100,100),rand_range(-100,100)))
				self.add_child(vent)
				vent.get_node("AnimationPlayer").connect("finished",vent,"queue_free")
			else:
				if(self.didacticiel==null):
					var fumee = FUMEE.instance()
					fumee.set_global_pos(Vector2(randi()%self.batiment.interieur.longueur,randi()%self.batiment.interieur.largeur))
					self.batiment.interieur.add_child(fumee)
			
		if(self.balle_bandit!=null && self.balle_joueur!=null):
			if(abs(self.balle_bandit.get_global_pos().y - self.balle_joueur.get_global_pos().y)<10):
				self.shader_ralenti.show()
				self.balle_bandit.VITESSE=0.5
				self.balle_joueur.VITESSE=0.5
#		if(self.balle_joueur!=null):
#			self.balle_joueur.move(balle_joueur.incrementer())
#		if(self.balle_bandit!=null):
#			self.balle_bandit.move(balle_bandit.incrementer())
#		if(self.debut_musique):
#			if(self.volume_musique<0):
#				print(self.volume_musique)
#				self.volume_musique+=0.1
#				#self.lecteur_musique.voice_set_volume_scale_db(self.volume_musique,0)
#			else:
#				self.debut_musique=false

#func debut_musique(piste):
#	self.lecteur_musique.play(piste)
#	self.volume_musique=-30
	#self.lecteur_musique.set_volume(0,-30)
#	self.debut_musique=true
#
#func fin_musique():
#	self.fin_musique=true

