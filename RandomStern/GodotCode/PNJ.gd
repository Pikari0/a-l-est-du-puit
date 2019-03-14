extends KinematicBody2D

var textures = [load("res://pnj1.png"),load("res://pnj2.png"),load("res://pnj3.png"),load("res://pnj4.png")]
var texture_medecin = load("res://medecin.png")
var texture_tavernier = load("res://tavernier.png")
var texture_scientifique_fou = load("res://scientifique_fou.png")

var sexe
var nom
var role

var repliques = []
var replique_courante = 0

# le role que va jouer le PNJ dans le scénario
var acteur = "figurant"
var replique_speciale = "Je ne sais rien."

var replique_action_presente_batiment_bandit = "Je t'en pose des questions, moi ?"
var replique_action_presente_batiment_autre = "Je t'en pose des questions, moi ?"

var anim_courante = "debout"

var texture = null

func _ready():
	self.texturer()

func parler():
	if(repliques.size()>0):
		replique_courante=(replique_courante+1)%repliques.size()
		return repliques[replique_courante]
	else:
		return "..."
		
func questionner():
	if(self.acteur=='temoin_batiment'):
		var plateau = get_tree().get_root().get_node("Plateau")
		if(plateau.batiment == plateau.interface_progression_intrigue.batiment_bandit):
			return self.replique_action_presente_batiment_bandit
		else:
			var replique = self.replique_action_presente_batiment_autre
			for mot in plateau.interface_progression_intrigue.batiment_bandit.nom.split(" "):
				replique += " [color=#FF0000]"+mot+"[/color]"
			return  replique+"."
	elif(self.acteur=='temoin_action'):
		var plateau = get_tree().get_root().get_node("Plateau")
		return self.replique_speciale + plateau.interface_progression_intrigue.action_courante[0] + "."
	else:	
		return replique_speciale

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

func tourner():
	var nouvelle_anim = "tourner"
	if(anim_courante!=nouvelle_anim):
		var anim = get_node("AnimationPlayer")
		anim.play(nouvelle_anim)
		anim_courante=nouvelle_anim

func texturer():
	var sprite = get_node("Sprite_Homme")
	if(texture==null):
		if(self.role=="medecin"):
			self.texture=self.texture_medecin
		elif(self.role=="tavernier"):
			self.texture=self.texture_tavernier
		elif(self.role=="scientifique_fou"):
			self.texture=self.texture_scientifique_fou
		else:
			self.texture=self.textures[randi()%self.textures.size()]
	sprite.set_texture(self.texture)			
		
func goutte(booleen):
	if(booleen):
		get_node("Goutte").show()
	else:
		get_node("Goutte").hide()
		
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
		
		