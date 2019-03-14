extends Node2D

signal fin_intro

var joueur_euse
var cactus
var appuyez_sur_start
var wanted

var sexe = 0

var chrono = 0

var etat_intro = "menu"
	
func _ready():
	cactus = get_node("Cactus")
	appuyez_sur_start = get_node("Appuyez sur Start")
	wanted = get_node("Wanted")
	joueur_euse = get_node("Joueur_euse")
	joueur_euse.sexe=sexe
	joueur_euse.mise_a_jour_sexe()
	#lancer_introduction()
	get_node("Camera2D").make_current()
	set_process(true)

func lancer_introduction():
	appuyez_sur_start.hide()
	joueur_euse.show()
	joueur_euse.set_pos(Vector2(512,600))
	joueur_euse.marche_haut()
	etat_intro="avant"
		
func _process(delta):
	if(Input.is_action_pressed("passer_cinematique")):
		joueur_euse.bruit_pas(false)
		emit_signal("fin_intro")
	if(Input.is_action_pressed("action") && etat_intro == "menu"):
		self.lancer_introduction()
	
	if(etat_intro=="avant" || etat_intro=="fin" ):
		if(chrono>0.02):
			joueur_euse.move(Vector2(0,-1))
			joueur_euse.bruit_pas(true)
			chrono=0
	
	if(etat_intro=="avant"):
		if(joueur_euse.get_pos().y<=cactus.get_pos().y):
			etat_intro="debout"
			joueur_euse.debout_droite()
			chrono=0
			joueur_euse.bruit_pas(false)
			
	if(etat_intro=="debout" && chrono>1):
		joueur_euse.hide()
		wanted.show()
		etat_intro="wanted"
		chrono=0
	
#	if(etat_intro=="debout" && chrono>1):	
#		joueur_euse.lecteur_musique.play("Dechire")
		
	if(etat_intro=="wanted" && chrono>5):
		joueur_euse.show()
		wanted.hide()
		joueur_euse.marche_haut()
		etat_intro="fin"
		get_node("CanvasLayer/Titre/AnimationPlayer").play("apparition")
	
	chrono+=delta

func _on_Area2D_body_enter( body ):
	joueur_euse.bruit_pas(false)
	self.emit_signal("fin_intro")

func change_nom_bandit(nom):
	wanted.change_nom_bandit(nom)
