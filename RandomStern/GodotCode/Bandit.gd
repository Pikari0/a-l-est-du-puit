extends KinematicBody2D

var sexe
var prenom
var nom
var qualificatif
var tic_langage

var mort = false

var monologues = ["Tu n'aurais jamais du te mêler de cette affaire, c'est ton arrêt de mort que tu viens de signer.",
	"Toute ma vie, j'ai cherché cette vengeance, je ne vais pas te laisser tout gâcher.",
	"Un de nous est en trop dans cette ville, et je vais m'empresser de faire le ménage."]

var anim_courante = "debout_haut"
var lecteur_musique

func _ready():
	lecteur_musique=get_node("SamplePlayer2D")

func monologuer():
	var monologue = monologues[randi()%monologues.size()]
	return monologue + " Je vais lancer cette pièce, lorsqu'elle s'immobilisera au sol, et pas avant, on verrons qui de nous deux est de trop." 

func parler():
	return "..."

func questionner():
	return "Assez joué, reglons ça."

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
		
	
func orienter_aleatoirement():
	randomize()
	var pos=randi()%4
	if(pos==0):
		self.debout_haut()
	elif(pos==1):
		self.debout_gauche()
	elif(pos==2):
		self.debout_droite()
	elif(pos==3):
		self.debout_bas()
		
func mourir():
	if(!self.mort):
		get_tree().get_root().get_node("Plateau").gameup()
		self.mort = true
		
func se_retourner(pos_joueur):
	var pos_pnj = self.get_pos()
	#print(abs(pos_pnj.x-pos_joueur.x))
	if(abs(pos_pnj.x-pos_joueur.x)>10):
		if(pos_pnj.x < pos_joueur.x):
			self.debout_droite()
		else:
			self.debout_gauche()
	else:
		if(pos_pnj.y > pos_joueur.y):
			self.debout_haut()
		else:
			self.debout_bas()