extends Node2D

signal nouveau_depart

var sexe = 0

var joueur_euse
var tilemap

func _ready():
	self.joueur_euse=get_node("Joueur_euse")
	self.joueur_euse.sexe=sexe
	self.joueur_euse.mise_a_jour_sexe()
	self.tilemap=get_node("TileMap")
	
	for x in range(-7,7):
		for y in range(0,10):
			self.tilemap.set_cell(x,y,randi()%4)
	
	self.joueur_euse.marche_haut()
	
	set_fixed_process(true)

func _fixed_process(delta):
	get_tree().get_root().get_node("Plateau").shader_coucher_soleil.show()
	if(Input.is_action_pressed("action")):
		emit_signal("nouveau_depart")
	self.joueur_euse.move(Vector2(0,-1))
	self.joueur_euse.camera_courante()
	
	var y_joueur = self.joueur_euse.get_pos().y
	for x in range(-7,7):
		self.tilemap.set_cell(x,y_joueur+1,randi()%4)
		
	if(randi()%150==0):
		var modele_cactus = get_node("Cactus")
		var autre_cactus = modele_cactus.duplicate()
		autre_cactus.set_pos(self.joueur_euse.get_pos()+Vector2(randi()%200-100,-200))
		if(abs(autre_cactus.get_pos().x-self.joueur_euse.get_pos().x)>20):
			self.add_child(autre_cactus)
	
	