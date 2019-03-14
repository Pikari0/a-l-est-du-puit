extends KinematicBody2D

signal a_marche
signal degaine
signal recharge
signal tir
signal trois_bullogue
signal intimide
signal questionne

var CLINT = load("res://clint.png")
var DOLORES = load("res://dolores.png")

var VITESSE = 1.2

var sexe = 1

var controllable = false
var duel = false
var pistolet_charge = false

var anim_courante = "debout_haut"

var precedent_bouton = ""

var partenaire = false
var mort = false

var pas = 0
var bullogues = 0

var lecteur_musique



func _ready():
	set_fixed_process(true)
	get_node("Camera2D").set_drag_margin(MARGIN_BOTTOM,0.05)
	get_node("Camera2D").set_drag_margin(MARGIN_RIGHT,0.05)
	get_node("Camera2D").set_drag_margin(MARGIN_LEFT,0.05)
	
	self.lecteur_musique=get_node("SamplePlayer2D")
	
	if(sexe):
		get_node("Sprite").set_texture(DOLORES)
	else:
		get_node("Sprite").set_texture(CLINT)
		
func _fixed_process(delta):
	if(pas>100):
		emit_signal("a_marche")
	if(bullogues>2):
		emit_signal("trois_bullogue")
	
	if(controllable || duel):
		if(Input.is_action_pressed("triche")):
			VITESSE=2.3
			var plateau = get_tree().get_root().get_node("Plateau")
			plateau.bullogue.ecrire(plateau.interface_progression_intrigue.batiment_bandit.nom,self)
		if(Input.is_action_pressed("degaine_pistolet")):
			emit_signal("degaine")
			get_tree().get_root().get_node("Plateau").interface_pistolet.charger()
			if("haut" in self.anim_courante):
				self.tir_haut()
			elif("bas" in self.anim_courante):
				self.tir_bas()
			elif("droite" in self.anim_courante):
				self.tir_droite()
			elif("gauche" in self.anim_courante):
				self.tir_gauche()
			if(Input.is_action_pressed("charge_pistolet")):
				if(!self.lecteur_musique.is_voice_active(1)):
					self.lecteur_musique.play("Charge",1)
				emit_signal("recharge")
				get_tree().get_root().get_node("Plateau").interface_pistolet.tirer()
				pistolet_charge = true
			if(pistolet_charge && Input.is_action_pressed("tir_pistolet")):
				if(!self.lecteur_musique.is_voice_active(2)):
					self.lecteur_musique.play("Tir",2)
				emit_signal("tir")
				get_tree().get_root().get_node("Plateau").interface_pistolet.tir()
				get_tree().get_root().get_node("Plateau").tir(self)
				pistolet_charge = false
		elif(controllable):
			var plateau = get_tree().get_root().get_node("Plateau")
			plateau.interface_pistolet.degainer()
			self.bruit_pas(true)
			if Input.is_action_pressed("haut"):
				self.marche_haut()
				self.move(VITESSE*Vector2(0,-1))
				precedent_bouton="haut"
				pas+=1
			elif Input.is_action_pressed("bas"):
				self.marche_bas()
				self.move(VITESSE*Vector2(0,1))
				precedent_bouton="bas"
				pas+=1
			elif Input.is_action_pressed("droite"):
				self.marche_droite()
				self.move(VITESSE*Vector2(1,0))
				precedent_bouton="droite"
				pas+=1
			elif Input.is_action_pressed("gauche"):
				self.marche_gauche()
				self.move(VITESSE*Vector2(-1,0))
				precedent_bouton="gauche"
				pas+=1
			else:
				self.lecteur_musique.stop_voice(0)
				if precedent_bouton=="haut":
					self.debout_haut()
				elif precedent_bouton=="bas":
					self.debout_bas()
				elif precedent_bouton=="gauche":
					self.debout_gauche()
				elif precedent_bouton=="droite":
					self.debout_droite()
					
			if(self.is_colliding()):
				var collider = self.get_collider()
				#print(collider.get_name())
				if(collider.get_name()=='Porte'):
					get_tree().get_root().get_node("Plateau").interieur(collider.get_parent())
				if(collider.get_name()=='Seuil'):
					get_tree().get_root().get_node("Plateau").exterieur()
#				if(collider.get_name()=='Bandit'):
#					get_tree().get_root().get_node("Plateau").duel_final()
				if(collider.has_method("parler")):
					if(Input.is_action_pressed("action")):
						var bullogue = get_tree().get_root().get_node("Plateau").bullogue
						if(!bullogue.is_visible() && bullogue.temps_depuis_fin>0.5):
							bullogue.ecrire(collider.parler(),collider)
							bullogues+=1
							if(collider.has_method("se_retourner")):
								collider.se_retourner(self.get_pos())
							#self.recentrer_camera()
				if(collider.has_method("questionner")):
					if(Input.is_action_pressed("questionner")):
						var plateau = get_tree().get_root().get_node("Plateau")
						var bullogue = plateau.bullogue
						if(!bullogue.is_visible() && bullogue.temps_depuis_fin>0.5):
							bullogue.ecrire(collider.questionner(),collider)
							#get_tree().get_root().get_node("Plateau").interface_progression_intrigue.increment_questionner()
							plateau.interface_couverture.interrogatoire()
							emit_signal("questionne")
							if(collider.has_method("se_retourner")):
								collider.se_retourner(self.get_pos())
							if("Bandit" in collider.get_name()):
								get_tree().get_root().get_node("Plateau").duel_final()
							#self.recentrer_camera()
					if(Input.is_action_pressed("intimider")):
						var plateau = get_tree().get_root().get_node("Plateau")
						var residents = plateau.batiment.residents
						plateau.interface_couverture.diminuer()
						
						for resident in residents:
							plateau.shader_intimider.show()
							if resident.acteur!="figurant":
#								var goutte = GOUTTE.instance()
#								resident.add_child(goutte)
#								goutte.set_pos(resident.get_pos()+Vector2(-5,0))
								resident.goutte(true)
						emit_signal("intimide")
					else:
						var plateau = get_tree().get_root().get_node("Plateau")
						if(plateau.batiment!=null):
							for resident in plateau.batiment.residents:
								resident.goutte(false)
						plateau.shader_intimider.hide()
					
func devient_controllable(booleen):
	if(booleen):
		controllable=true
		get_node("Camera2D").make_current()
	else:
		controllable=false

func camera_courante():
	get_node("Camera2D").make_current()

func mise_a_jour_sexe():
	if(sexe):
		get_node("Sprite").set_texture(DOLORES)
	else:
		get_node("Sprite").set_texture(CLINT)

func duel(booleen):
	devient_controllable(false)
	self.duel = booleen
	
func recentrer_camera():
	get_node("Camera2D").align()

func debout_haut():
	var nouvelle_anim = "debout_haut"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func debout_bas():
	var nouvelle_anim = "debout_bas"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func debout_gauche():
	var nouvelle_anim = "debout_gauche"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func debout_droite():
	var nouvelle_anim = "debout_droite"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func marche_haut():
	var nouvelle_anim = "marche_haut"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func marche_bas():
	var nouvelle_anim = "marche_bas"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func marche_gauche():
	var nouvelle_anim = "marche_gauche"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim
		
func marche_droite():
	var nouvelle_anim = "marche_droite"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func tir_droite():
	var nouvelle_anim = "tir_droite"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func tir_gauche():
	var nouvelle_anim = "tir_gauche"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim
		
func tir_haut():
	var nouvelle_anim = "tir_haut"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim
		
func tir_bas():
	var nouvelle_anim = "tir_bas"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim
		
func mourir():
	if(!partenaire && !self.mort):
		if(!get_tree().get_root().get_node("Plateau").duel):
			get_tree().get_root().get_node("Plateau").gameover()
		self.mort = true

func bruit_pas(actif):
	if(actif):
		if(self.lecteur_musique!= null && !self.lecteur_musique.is_voice_active(0)):
			var plateau = get_tree().get_root().get_node("Plateau")
			if(plateau.batiment==null):
				self.lecteur_musique.play("Pas_Exterieur",0)
			else:
				self.lecteur_musique.play("Pas_Interieur",0)
	else:
		self.lecteur_musique.stop_voice(0)
		
func pause(oui):
	if(oui):
		set_fixed_process(false)
	else:
		set_fixed_process(true)