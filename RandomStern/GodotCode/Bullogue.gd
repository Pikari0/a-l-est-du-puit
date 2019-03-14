extends Node2D

signal fin_replique

var repliques = []
var caracteres_visibles = 0
var numero_replique
var label
var lecteur_musique

# sert à éviter de relancer un dialogue par mégarde
var temps_depuis_fin = 0
# sert à ne pas passer trop vite sur une bulle
var temps_depuis_action = 0

func _ready():
	self.label = get_node("RichTextLabel")
	self.lecteur_musique = get_node("SamplePlayer2D")
	#ecrire(["Bonjour, je viens vous aider. Comment va votre jambe ?",
	#"Il ne faut pas laisser ça traîner.",
	#"Cela pourrait s'infecter. Par ici, Suivez-moi dans mon bureau.",
	#"J'ai ce qu'il faut pour vous."],null)
	set_process(true)

func _process(delta):
	if(self.is_visible()):
		if(!self.lecteur_musique.is_voice_active(0)):
			self.lecteur_musique.play("Machine_A_Ecrire",0)
		label.set_visible_characters(caracteres_visibles)
		if(caracteres_visibles<label.get_total_character_count()):
			caracteres_visibles+=1
		else:
			self.lecteur_musique.stop_all()
			if(Input.is_action_pressed("action") && temps_depuis_action > 0.5):
				temps_depuis_action=0
				if(numero_replique+1<repliques.size()):
					numero_replique+=1
					label.set_bbcode(repliques[numero_replique])
					caracteres_visibles=0
				else:
					self.hide()
					self.emit_signal("fin_replique")
					temps_depuis_fin=0
		temps_depuis_action+=delta
	else:
		temps_depuis_fin += delta

func force_fin():
	self.hide()
	temps_depuis_fin=0

func ecrire(replique,personnage):
	if(personnage!=null):
		self.set_pos(personnage.get_global_pos()+Vector2(0,-32))
	self.show()
	self.repliques=[]
	
	var LG_MIN = 36
	var tableau_mots = replique.split(" ")
	var phrase = ""
	var nb_mots = tableau_mots.size()
	for m in range(nb_mots):
		phrase += tableau_mots[m] + " "
		if(m+1<nb_mots && (phrase+tableau_mots[m+1]).replace("[color=#FF0000]","").replace("[/code","").length()>=LG_MIN):
			#print((phrase+tableau_mots[m+1]).length())
			self.repliques.append(phrase)
			phrase=""
	self.repliques.append(phrase)
	
#	var nb_coupes = (replique.length()/LG_MIN) + 1
#	for i in range(nb_coupes):
#		var s = replique.substr(i*LG_MIN,(i+1)*LG_MIN)
#		self.repliques.append(s)
		
	label.set_bbcode(repliques[0])
	numero_replique = 0
	caracteres_visibles = 0