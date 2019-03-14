extends Node2D

signal reveil

var PNJ = load("res://PNJ.tscn")

var sexe = 0
var bullogue

var joueur_euse
var partenaire

var residents = []

func _ready():
	get_node("AnimationPlayer").play_backwards("fin")
	get_tree().get_root().get_node("Plateau").shader_reve.show()
	get_tree().get_root().get_node("Plateau").lecteur_musique.play("Reve")
	
	self.joueur_euse = get_node("Joueur_euse")
	self.partenaire = get_node("Partenaire")
	self.partenaire.partenaire = true
	self.joueur_euse.sexe=self.sexe
	if(self.sexe):
		self.partenaire.sexe=0
	else:
		self.partenaire.sexe=1
	self.joueur_euse.mise_a_jour_sexe()
	self.partenaire.mise_a_jour_sexe()
	
	self.partenaire.debout_bas()
	self.joueur_euse.debout_haut()
	
	self.bullogue = get_node("Bullogue")

	randomize()
	for i in range(3):
		var pnj = PNJ.instance()
		pnj.orienter_aleatoirement()
		pnj.set_pos(self.partenaire.get_pos()-Vector2(150+randi()%30,i*32))
		pnj.repliques.append("Laissez moi tranquille.")
		self.add_child(pnj)
		self.residents.append(pnj)
	
	var clef = self.residents[randi()%self.residents.size()]
	clef.acteur = "clef"
	clef.replique_speciale="Réveillez-vous. C'est l'heure."

	self.deplacements()
	
	set_process(true)
	
func _process(delta):
	if(Input.is_action_pressed("passer_cinematique")):
		get_tree().get_root().get_node("Plateau").lecteur_musique.stop_all()
		emit_signal("reveil")
	
func deplacements():
	self.joueur_euse.pause(true)
	self.bullogue.ecrire("Bon, comment ça va ? [Entrée] ..... Voyons si tu n'as rien oublié maintenant que tu es sur pieds. Fais donc quelques pas avec ZQSD.",self.partenaire)
	self.joueur_euse.devient_controllable(true)
	self.bullogue.connect("fin_replique",self.joueur_euse,"pause",[false],CONNECT_ONESHOT)
	self.joueur_euse.connect("a_marche",self,"degaine",[],CONNECT_ONESHOT)
	
func degaine():
	#self.joueur_euse.pause(true)
	self.bullogue.ecrire("Ah, ça fait plaisir de voir que tu es toujours en forme. Mais n'as-tu pas perdu ta dextérité légendaire ? Dégaine ton pistolet avec [Espace].",self.partenaire)
	#self.bullogue.connect("fin_replique",self.joueur_euse,"pause",[false],CONNECT_ONESHOT)
	self.joueur_euse.connect("degaine",self,"recharge",[],CONNECT_ONESHOT)		

func recharge():
	#self.joueur_euse.pause(true)
	self.bullogue.ecrire("Toujours en le tenant, charge avec [G].",self.partenaire)
	#self.bullogue.connect("fin_replique",self.joueur_euse,"pause",[false],CONNECT_ONESHOT)
	self.joueur_euse.connect("recharge",self,"tir",[],CONNECT_ONESHOT)

func tir():
	#self.joueur_euse.pause(true)
	self.bullogue.ecrire("Enfin tire avec [MAJ] !",self.partenaire)
	#self.bullogue.connect("fin_replique",self.joueur_euse,"pause",[false],CONNECT_ONESHOT)
	self.joueur_euse.connect("tir",self,"parle",[],CONNECT_ONESHOT)
	
func parle():
	self.joueur_euse.pause(true)
	self.partenaire.debout_gauche()
	self.bullogue.ecrire("Bien ! C'est le moment de voir si tu n'as rien perdu de ton éloquence. Va donc parler avec [Entrée] aux personnes là bas.",self.partenaire)
	self.bullogue.connect("fin_replique",self.joueur_euse,"pause",[false],CONNECT_ONESHOT)
	self.joueur_euse.connect("trois_bullogue",self,"intimide",[],CONNECT_ONESHOT)
	
func intimide():
	self.joueur_euse.pause(true)
	self.bullogue.ecrire("N'oublie pas que tu peux lire les panneaux de la même manière. Bon, ils n'ont pas grand chose à dire on dirait. Essaye de les intimider avec [*].",self.partenaire)
	self.bullogue.connect("fin_replique",self.joueur_euse,"pause",[false],CONNECT_ONESHOT)
	self.joueur_euse.connect("intimide",self,"questionne",[],CONNECT_ONESHOT)
	
func questionne():
	self.joueur_euse.pause(true)
	self.bullogue.ecrire("Bien ! Cependant agir de cette façon attire l'attention et te fera perdre ta couverture. Regarde on dirait que l'un d'entre eux semble avoir des informations supplémentaires. Utilise [$] pour le questionner.",self.partenaire)
	self.bullogue.connect("fin_replique",self.joueur_euse,"pause",[false],CONNECT_ONESHOT)
	self.joueur_euse.connect("questionne",get_tree().get_root().get_node("Plateau").bullogue,"connect",["fin_replique",self,"fin",[],CONNECT_ONESHOT],CONNECT_ONESHOT)
	#self.joueur_euse.connect("questionne",self,"fin",[],CONNECT_ONESHOT)

func fin():
	self.joueur_euse.pause(true)
	self.bullogue.ecrire("Tu as bien repris tes habitudes. Allez je te laisse tracer ta route et ta chasse aux bandits. Profite de la vie, et fait le bien autour de toi. Je t'aime.",self.partenaire)
	self.bullogue.connect("fin_replique",get_node("AnimationPlayer"),"play",["fin"],CONNECT_ONESHOT)
	get_node("AnimationPlayer").connect("finished",self.joueur_euse,"pause",[false],CONNECT_ONESHOT)
	get_node("AnimationPlayer").connect("finished",get_tree().get_root().get_node("Plateau").lecteur_musique,"stop_all",[],CONNECT_ONESHOT)
	get_node("AnimationPlayer").connect("finished",self,"emit_signal",["reveil"],CONNECT_ONESHOT)

	