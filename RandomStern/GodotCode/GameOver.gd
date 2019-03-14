extends Node2D

signal nouveau_depart

var ENFANT = load("res://Joueur_euse_Enfant.tscn")

var joueur_euse
var enfant

var replique = null
var grandir = false

var sexe = 0

func _ready():
	randomize()
	self.joueur_euse=get_node("Joueur_euse")
	self.enfant=get_node("Joueur_euse_Enfant")
	self.joueur_euse.sexe=self.sexe
	self.joueur_euse.mise_a_jour_sexe()
	self.enfant.sexe=self.sexe
	self.enfant.mise_a_jour_sexe()
	
	self.joueur_euse.camera_courante()
	
	self.joueur_euse.set_opacity(0)
	self.enfant.set_opacity(1)
	set_fixed_process(true)


func _fixed_process(delta):
	if(!self.grandir):
		if(self.replique==null && Input.is_action_pressed("action")):
			if(self.joueur_euse.sexe):
				self.replique="Maman..."
			else:
				self.replique="Papa..."
			var bullogue = get_node("Bullogue")
			bullogue.ecrire(self.replique,enfant)
			bullogue.connect("fin_replique",self,"grandir")
	else:	
		if(!get_node("AnimationPlayer").is_playing()):
			get_node("CanvasLayer/Appuyez_sur_Entree").show()
			self.enfant.marcher()
			self.joueur_euse.marche_haut()
			
			self.enfant.move(Vector2(0,-1))
			self.joueur_euse.move(Vector2(0,-1))
			
			self.enfant.set_opacity(self.enfant.get_opacity()-0.001)
			self.joueur_euse.set_opacity(self.joueur_euse.get_opacity()+0.001)
			# cactus qui passent, vraiment important
			if(randi()%150==0):
				var modele_cactus = get_node("Cactus")
				var autre_cactus = modele_cactus.duplicate()
				autre_cactus.set_pos(self.enfant.get_pos()+Vector2(randi()%200-100,-200))
				if(abs(autre_cactus.get_pos().x-joueur_euse.get_pos().x)>20):
					self.add_child(autre_cactus)
			if(Input.is_action_pressed("action")):
				self.emit_signal("nouveau_depart")
		
func grandir():
	get_node("Bullogue").disconnect("fin_replique",self,"grandir")
	self.get_node("AnimationPlayer").play("grandir")
	self.grandir=true