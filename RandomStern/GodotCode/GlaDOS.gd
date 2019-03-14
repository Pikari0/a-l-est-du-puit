extends Node2D

var VILLE = load("res://Ville.tscn")
var BANDIT = load("res://Bandit.tscn")
var PNJ = load("res://PNJ.tscn")
var BATIMENT = load("res://Batiment_v2.tscn")

const HOMME=0
const FEMME=1 # FEMME > HOMME ^^

const NB_REPLIQUES_NORMALES = 1

func gene():
	var ville = geneVille()
	geneBandit(ville)
	geneAction(ville)
	geneSubtilite(ville)
	geneBatiments(ville)
	geneDialogues(ville)
	geneHabitants(ville)

	return ville

func geneBandit(ville):
	randomize()
	
	var prenoms = { HOMME : ["John","Jack","Lewis","Freddy","Clint","Lupin"],
			FEMME : ["Jeanne","Claire","Fiona","Anne"] }
	var noms = ["Dupont","Poisse","ForetVerte","Chanterelle","Télien","Cousseil","Grenampe","Socube","Voyapé","Desteur"]
	var qualificatifs = { HOMME : ["L'étranger","Le terrible","La gachette","La terreur","L'effroyable","Le sauvage","Le mécanicien"],
			FEMME : ["L'arstiste","Sans peur","La destruction","La tueuse","L'invaincue"] }
	var tics_langage = ["z remplace s","f remplace s",", n'est-ce-pas ?",", quoi.","l remplace r",", hein.",", oui ?",", compris ?","th remplace d","ai remplace é"]
						
	var bandit = BANDIT.instance()
	bandit.sexe = randi()%2
	bandit.prenom = prenoms[bandit.sexe][randi()%prenoms[bandit.sexe].size()]
	bandit.nom = noms[randi()%noms.size()]	
	bandit.qualificatif = qualificatifs[bandit.sexe][randi()%qualificatifs[bandit.sexe].size()]	
	bandit.tic_langage = tics_langage[randi()%tics_langage.size()]
	
	ville.bandit=bandit
	
func geneAction(ville):
	randomize()
	
#	var actions_non_finales = ["monte les habitants contre le shérif",
#		"tue les employés de la banque",
#		"cambriole un magasin d'armes",
#		"vole des chevaux",
#		"affronte le shérif en duel",
#		"libère des prisionniers",
#		"arrache les affiches de recherche",
#		"ajoute des zéro sur son affiche",
#		"se détent au saloon",
#		"joue au cartes",
#		"recrute des habitants"]
#	var actions_finales = ["s'enfuit",
#		"tue le shérif",
#		"brule un saloon",
#		"prend le train",
#		"enlève la fille du maire",
#		"s'accage la ville"]
	
	var actions = [["monter les habitants contre le shérif",'saloon'],
		["cambrioler un commerce",'commerce'],
		["tuer le shérif",'bureau_sherif'],
		["bruler un saloon",'saloon'],
		["entreposer des explosifs",'entrepot'],
#		["rechercher la recette d'un explosif surpuissant",'laboratoire_scientifique_fou'],
		["détrousser des malades",'cabinet_medecin']]
		
	var nb_actions = randi()%2+3
	for i in range(nb_actions):
		ville.actions.append(actions[randi()%actions.size()])
	
	print(actions)
	
func geneSubtilite(ville):
	var subtilites = ["le bandit est épileptique","une tempête balaie la ville toutes les heures","le bandit est orphelin","il y y a un traitre parmi les complices","le bandit s'est trompé de ville","un jeune de la ville joue au héro","la ville est le théâtre d'une histoire d'amour impossible","un énorme fossile de dinosaure vient d'être découvert au centre de la ville","un groupe de musique ultra-populaire se produit dans la ville","la ville vénère les chats","le bandit meurt accidentellement en glissant dans une baignoire","un vaisseau spatial est caché dans un entrepôt","un journaliste suit le joueur partout","la ville dispose d'une station de ski","l'intrigue se passe pendant le nouvel an"]
	
	ville.subtilite = subtilites[randi()%subtilites.size()]
	
func geneVille():
	randomize()
	var noms = ["Dernière étape avant la mort","Le jeton doré","Bois-Flotté","Paturages fannés","Vaches et moutons","Poussière de brume","Mortière","Charbon Brute","Samville","Cafebourg"]
	
	var ville = VILLE.instance()
	ville.nom = noms[randi()%noms.size()]
	ville.nb_saloons = randi()%3+1
	ville.nb_cabinets_medecin = randi()%1+1
	ville.nb_bureaux_sherif = 1
	ville.nb_tombes_cimetiere = randi()%50+20
	ville.nb_entrepots = randi()%2+2
	ville.nb_laboratoires_scientifique_fou = randi()%2
	ville.nb_puits = randi()%2+1
	ville.nb_commerces = randi()%1+1
	
	return ville



func geneBatiments(ville):
	randomize()
	
	var noms_saloons=['Jamais à sec','À la longue','Nuances d\'orange','Idée du vent','Science infuse','Le repos du desert','L\'éclair intriguant','L\'appel de l\'aventure','Le cercle perdu','Le relai du piano','Les merveilles des thermes']
	for s in range(ville.nb_saloons):
		var saloon = BATIMENT.instance()
		var index = randi()%noms_saloons.size()
		saloon.nom = noms_saloons[index]
		noms_saloons.remove(index)
		saloon.type="saloon"
		ville.batiments.append(saloon)
		
	var noms_cabinets_medecin=["Bonheur de vivre","Joie dans le coeur","Puissance santé","Se soigner avec le sourire","Dans tes dents"]
	for m in range(ville.nb_cabinets_medecin):
		var cabinet_medecin = BATIMENT.instance()
		var index = randi()%noms_cabinets_medecin.size()
		cabinet_medecin.nom = noms_cabinets_medecin[index]
		noms_cabinets_medecin.remove(index)
		cabinet_medecin.type="cabinet_medecin"
		ville.batiments.append(cabinet_medecin)
		
	for b in range(ville.nb_bureaux_sherif):
		var bureaux_sherif = BATIMENT.instance()
		bureaux_sherif.nom = "Bureau du Shérif"
		bureaux_sherif.type="bureau_sherif"
		ville.batiments.append(bureaux_sherif)
		
	#var cimetiere = BATIMENT.instance()
	#cimetiere.nom="Cimetière de "+ville.nom
	#cimetiere.type="cimetiere"
	#ville.batiments.append(cimetiere)
	
	for e in range(ville.nb_entrepots):
		var entrepot = BATIMENT.instance()
		entrepot.nom = "Entrepot "+String(e)
		entrepot.type = "entrepot"
		ville.batiments.append(entrepot)
		
	for l in range(ville.nb_laboratoires_scientifique_fou):
		var laboratoire_scientifique_fou = BATIMENT.instance()
		laboratoire_scientifique_fou.nom = "Laboratoire, restez dehors"
		laboratoire_scientifique_fou.type = "laboratoire_scientifique_fou"
		ville.batiments.append(laboratoire_scientifique_fou)
	
	var noms_commerces=["Le bazar du désert","La galerie des trésors","Un petit bout d'Orient","Aux prix bas","Au champs","Bidules pour tous","Achetez, achetez, achetez"]
	for c in range(ville.nb_commerces):
		var commerce = BATIMENT.instance()
		var index = randi()%noms_commerces.size()
		commerce.nom = noms_commerces[index]
		#noms_commerces.remove(index)
		commerce.type= "commerce"
		ville.batiments.append(commerce)
	
#	var deja_places = []
#	for batiment in ville.batiments:
#		var nb_residents = randi()%6+4
#		for n in range(nb_residents):
#			var choosen_one = ville.habitants[randi()%ville.habitants.size()]
#			if !deja_places.has(choosen_one):
#				batiment.residents.append(choosen_one)
#				deja_places.append(choosen_one)
	
func geneDialogues(ville):
	for batiment in ville.batiments:
		if batiment.type == 'cabinet_medecin':
			var repliques_medecin = ["Ici nous soignons tout, prenez donc un ticket.",
			"Entrez ! Bienvenue dans mon humble cabinet.",
			"Mes méthodes sont les meilleures, je vous garanti le retablissement.",
			"Oh, je vois que vous souffrez d'asthme, venez j'ai un remède.",
			"Mon taux de mortalité est le plus bas du pays !",
			"Bien des confrères pratique le hasard et une certaine force de mysticisme dans leur consultations, pour ma part je me borne à le seule science.",
			"La vie est trop belle pour mourrir, venez donc vous faire osculter.",
			"Vous êtes à jour de vos vaccins ? Et les rappels ? Venez par ici que je vérifie.",
			"Soigner c'est ma passion, soyez sans crainte, les gens qui ressortent de mon cabinets sont toujours bien mieux portant (quand ils ressortent, biensur)",
			"J'aromatise mes potions avec une multitude de parfums, choississez selon vos goûts !",
			"Pour une consultation adulte, j'offre une consultation enfant ! N'hésitez plus à prendre soin de votre progéniture !",
			"La vie est trop courte pour être vécue malade, venez vous soigner.",
			"D'Est en Ouest, je suis reconnu pour le bon traitement de mes patients, soyez rassuré.",
			"Je vous sens un peu faible, ne soyez pas timide. Je ne suis pas cher du tout, et vous en sortirez satisfait",
			"Le monde de la médecine est beaucoup trop dérégulé, voyez tout ces imposteurs qui brade leur soin à tout va.",
			"Je suis peut être cher, mais vous ne trouverez pas meilleur medecin sur des kilomètres !",
			"Si vous n'êtes pas malade, sortez de mon cabinet, vous gênez les patients. J'ai déjà assez de travail comme cela.",
			"En plus de mon activité de thérapeute, je fais aussi de la recherche, j'espère un jour découvrir la panacée.",
			"Pardonnez-moi mais je suis déjà surchargé, il faudra attendre qu'un de mes patients meurre pour avoir une place.",
			"Vous rêvez encore Mr Cobb ?",
			"Je conçois mes propres remède, avec des composés naturels, parce qu'il n'y a pas besoin de plus.",
			"On me traite souvent de fou, la varité c'est que les autres ont peur que je dévoile au yeux du monde leur imposture",
			"Vous n'êtes pas là pour me voler mes méthodes, hein ? Déjà la semaine dernière, j'ai vu des gens roder autour de mon cabinet",
			"Le monde est ingrat, je permet à tous de vivre mieux et plus longtemps, en échange regardez le pauvre cabinet où je suis réduit à pratiquer",
			"Si l'envie vous en prend, ne faites pas d'études de médecine, ça ne vous apportera que le malheur.",
			"Vous ne recheriez pas à vous reconvertir ? J'aurais besoin d'un assistant, pas besoin de compétence, juste de la bonne volontée et de la patience.",
			"J'en ai assez, je ne prend plus de patients, dès que les derniers seront soignés ou décédés, je rend mes outils.",
			"On a besoin de plus de médecins ! Engagez-vous, pour le bien de la société.",
			"Sans médecin, à quoi serait-on réduits ? Alors que vous, le chien errant, qui a besoin de vous ?",
			"Je ne soigne pas les étrangers, passez votre chemin",
			"Je ne suis endetté au près du maire, maintenant je donne des consultations gratuites pour éponger ma dette.",
			"Aucune gratitude, j'en ai assez de cette ville. Tous des ingrats.",
			"L'être humain est une vraie source d'étonnement, laissez-moi vous examiner, vos voyages ont dû transformer votre corps.",
			"Je soigne tout le monde, que vous soyez bandit ou pasteur, tant que vous payez.",
			"N'oubliez pas que la digestion est vraiment importante, la première chose auquel un humain devrait penser.",
			"Vous mangez équilibré ? Je peux vous proposer mes régimes tout préparés, en partenariat avec le commerçant du bout de la rue.",
			"Brossez-vous les dents régulièrement, pour vous et pour les autres.",
			"Vous vous rendez compte de l'impact que votre vie de dépravé a sur votre corps ? Abandonnez cette carière qui ne vous amènera qu'à la mort.",
			"Oh, quel honneur de vous avoir dans mon cabinet, merci pour ce que vous faîtes à l'Ouest, on a besoin de gens comme vous.",
			"Chaque matin, je regarde une souris sortir de sous mon bureau, et cela me rempli de détermination."]
			# le premier PNJ est le medecin
			var medecin = PNJ.instance()
			medecin.role='medecin'
			medecin.sexe=randi()%2
			for i in range(NB_REPLIQUES_NORMALES):
				medecin.repliques.append(repliques_medecin[randi()%repliques_medecin.size()])
			batiment.residents.append(medecin)
			ville.habitants.append(medecin)
			
			var repliques_residents_cabinet_medecin = [ "Ça fait six tampons sur ma carte de patient, vous croyez que j'aurais un cadeau ?",
			"Je vais mourir, laissez moi, je ne sens déjà plus mon doigt. Je n'aurais jamais du forcer pour ouvrir ce paquet de pâtes.",
			"Regardez, regardez, ma main est bleue !",
			"Ce médecin est vraiment cher, si vous en trouvez un autre, allez-y.",
			"Déjà 2 jours que mon rendez-vous est déplacé, heureusement qu'il y a de la lecture.",
			"Je ne suis pas un patient, je me cache simplement ici le temps que tout ce tasse dehors, vous ne pouvez imaginer quelle belle planque c'est.",
			"Oh, bonne chance dans vos activités, il faut bien du courage.",
			"Je mange beaucoup trop, mais je ne peux pas m'en empêcher, tenez, empêchez moi de manger ce gâteau.",
			"Cela fait six ans que je consulte ici, je n'ai jamais été déçu.",
			"Je mange une pomme chaque matin, et pourtant me voilà ici.",
			"C'est bon, la sortie est là, au moindre bruit suspect, je cours.",
			"Routine du matin, une petite consultation, pour vérifier que tout continue d'aller pour le mieux.",
			"Je ne suis pas malade, je suis simplement amoureux du médecin, mais ne répétez pas.",
			"Encore six médecins à essayer dans la région pour enfin faire mon choix.",
			"Pourvu qu'il ne renouvelle pas le sirop, je ne pourrais supporter le goût infâme plus longtemps.",
			"Tant d'attente pour un simple certificat de bonne santé, les cours de golf ont intérêt à être bons.",
			"Je suis convaincu que des machines mécaniques pourront faire le travail des médecins dans ma futur."]
			# le reste est les patients
			var nb_patients = randi()%3
			for i in range(nb_patients):
				var patient = PNJ.instance()
				patient.role='patient'
				patient.sexe=randi()%2
				for n in range(NB_REPLIQUES_NORMALES):
					patient.repliques.append(repliques_residents_cabinet_medecin[randi()%repliques_residents_cabinet_medecin.size()])
				batiment.residents.append(patient)
				ville.habitants.append(patient)
				
		elif(batiment.type=='commerce'):
			var repliques_commercant = ['Bonjour et bienvenue dans ma boutique.',
			"Faites votre choix, j'ai tout ce que qu'humain puisse désirer.",
			"Trois produits achetés, le quatrième offert !",
			"Dépêcher vous de choisir, je ferme dans quelques minutes.",
			"Que des produits locaux, n'hésitez plus !"]
			#le premier résident est le commerçant
			var commercant = PNJ.instance()
			commercant.sexe=randi()%2
			commercant.role='commercant'
			for i in range(NB_REPLIQUES_NORMALES):
				commercant.repliques.append(repliques_commercant[randi()%repliques_commercant.size()])
			batiment.residents.append(commercant)
			
			var repliques_clients_commerce = ['Wow, tant de choix !',"C'est vachement cher, tous des voleurs ces commerçants."]
			# le reste est les clients du commerce
			var nb_clients = randi()%7
			for i in range(nb_clients):
				var client = PNJ.instance()
				client.sexe=randi()%2
				client.role='client'
				for n in range(NB_REPLIQUES_NORMALES):
					client.repliques.append(repliques_clients_commerce[randi()%repliques_clients_commerce.size()])
				batiment.residents.append(client)
				ville.habitants.append(client)
				
				
		elif(batiment.type=='bureau_sherif'):
			var repliques_sherif = ["La loi c'est moi.",
			"Merci de votre travail citoyen, vous m'aidez bien.",
			"Regardez comme la prison est petite, c'est tout de même bien plus facile de les descendre comme vous faîtes."]
			# le premier résident est le shérif
			var sherif = PNJ.instance()
			sherif.role='sherif'
			sherif.sexe=randi()%2
			for i in range(NB_REPLIQUES_NORMALES):
				sherif.repliques.append(repliques_sherif[randi()%repliques_sherif.size()])
			batiment.residents.append(sherif)
			ville.habitants.append(sherif)
			
			var repliques_passants_bureau_sherif = ["J'aimerias signaler un vol.",
			"Vivement que ce shérif se fasse descendre, il est complètement corrompu."]
			# le reste est les passants dans le bureau du shérif
			for i in range(batiment.residents.size()-1):
				var passant = PNJ.instance()
				passant.sexe=randi()%2
				passant.role='passant'
				for n in range(NB_REPLIQUES_NORMALES):
					passant.repliques.append(repliques_passants_bureau_sherif[randi()%repliques_passants_bureau_sherif.size()])
				batiment.residents.append(passant)
				
		elif(batiment.type=='saloon'):
			var repliques_tavernier = ["Qu'est-ce que je vous sert ?",
			"Qu'est-ce que ce sera ?",
			"Ici, nous servons les meilleures boissons du désert !",
			"Si monsieur veut bien se donner la peine de choisir.",
			"Pardon, mais nous ne servons pas les vagabons.",
			"Prenez garde, les gens sont très susceptibles par ici.",
			"Pourriez-vous éviter de causer une bagarre, jai déjà une dizaine de sièges cassés dans l'arrière boutique.",
			"Venez donc vous déshalterer, vous en aurez bien besoin."]
			# le tavernier
			var tavernier = PNJ.instance()
			tavernier.role='tavernier'
			tavernier.sexe=randi()%2
			for i in range(NB_REPLIQUES_NORMALES):
				tavernier.repliques.append(repliques_tavernier[randi()%repliques_tavernier.size()])
			batiment.residents.append(tavernier)
			ville.habitants.append(tavernier)
			# les serveurs
			#var nb_serveurs = randi()%5
			#for i in range(nb_serveurs):
			#	var serveur = PNJ.instance()
			#	serveur.role='serveur'
			#	batiment.residents.append(serveur)
			# le musicien
			var musicien = PNJ.instance()
			musicien.role='musicien'
			musicien.sexe=randi()%2
			batiment.residents.append(musicien)
			ville.habitants.append(musicien)
			# les joueurs de carte
			var repliques_joueurs_de_cartes = ["Prend ça ! Par ici la monnaie.",
			"Ne me parlez pas, je suis concentré.",
			"Fait voir ta manche, tu triches j'en suis certain.",
			"C'est mon jeu, c'est moi qui décide des règles.",
			"Voilà, tu viens de perdre ta propriété, on continue ?",
			"Tu gagnes à chaque fois ! C'est louche.",
			"Si tu gagnes encore un seule fois, on règlera ça par un duel !",
			"Des menaces, toujours des menaces, et si tu jouais plutôt ?",
			"Vous n'êtes vraiment que des débutants dans ce trou paumé.",
			"Tu me fais honte, joue mieux que ça !",
			"Que... quoi, non ! Ce n'es pas possible !",
			"Je relance.",
			"Je te vois, à regarder au dessus de mon épaule.",
			"Regardez ce tour, ce je l'ai appris dans une petite ville à l'Ouest d'ici.",
			"Ton jeu est truqué ! Je refuse de continuer.",
			"Rappelez moi les règles, cela fait une éternité que je n'ai pas joué."]
			var nb_joueurs_de_cartes = randi()%6+2
			for i in range(nb_joueurs_de_cartes):
				var joueur_de_cartes = PNJ.instance()
				joueur_de_cartes.role = 'joueur_de_cartes'
				joueur_de_cartes.sexe=randi()%2
				for i in range(NB_REPLIQUES_NORMALES):
					joueur_de_cartes.repliques.append(repliques_joueurs_de_cartes[randi()%repliques_joueurs_de_cartes.size()])
				batiment.residents.append(joueur_de_cartes)
				ville.habitants.append(joueur_de_cartes)
			# les clients à table
			var repliques_clients_a_table = ["Quand je te le dis, on ne peut pas s'y fier.",
			"C'est vrai, tu as raison.",
			"Non, vraiment ?! Lui ?",
			"Il va se faire descendre, c'est clair, je en lui donne pas deux mois.",
			"Tu sais ce que l'on raconte ? Il y a un étranger à la recherche d'un bandit en ville.",
			"Je déteste ces justiciers qui se mèlent se ce qui ne les regarde pas.",
			"Des taxes, des taxes, j'ai l'impression que c'est le seul moyen de pression qu'à le gouverneur.",
			"L'argent doit circuler, je te le dis.",
			"Regarde ta main invisible du marché, tu crois que ça fonctionne ? Tu te sens en sécurité ici ?",
			"Je la je lui dit d'aller se faire voir ! Tu n'imagines pas sa tête.",
			"Mais oui, je te le dit, je l'ai vu avec cette femme.",
			"De telles manières me dégoutent au plus au point.",
			"Tu veux que je te dise, que hein.. Non mais c'est vrai. Quoi.",
			"Rien de mieux que l'eau ferrigineuse.",
			"J'aime me battre.",
			"L'argent ne fait pas le bonheur, pense à ta famille mon vieux.",
			"T'imagine pas sur quoi je suis tombé l'autre jour. *beurp* Une mine d'or ! *beurp* Puisque je te le dit. Et facile à exploiter en plus."]
			var nb_clients_a_table = randi()%15+10
			for i in range(nb_clients_a_table):
				var client_a_table = PNJ.instance()
				client_a_table.role = 'client_a_table'
				client_a_table.sexe=randi()%2
				for i in range(NB_REPLIQUES_NORMALES):
					client_a_table.repliques.append(repliques_clients_a_table[randi()%repliques_clients_a_table.size()])
				batiment.residents.append(client_a_table)
				ville.habitants.append(client_a_table)
			# les clients au comptoir
			var repliques_clients_au_comptoir = ["Laisse moi tranquille minus.","Les étrangers ne sont pas les bienvenus ici."]
			var nb_clients_au_comptoir = randi()%5+5
			for i in range(nb_clients_au_comptoir):
				var client_au_comptoir= PNJ.instance()
				client_au_comptoir.sexe=randi()%2
				client_au_comptoir.role = 'client_au_comptoir'
				for i in range(NB_REPLIQUES_NORMALES):
					client_au_comptoir.repliques.append(repliques_clients_au_comptoir[randi()%repliques_clients_au_comptoir.size()])
				batiment.residents.append(client_au_comptoir)
				ville.habitants.append(client_au_comptoir)

		elif(batiment.type=='laboratoire_scientifique_fou'):
			var repliques_scientifique_fou = ["Hum, rendez-vous utile, tenez-moi cette fiole."]
			var scientifique_fou = PNJ.instance()
			scientifique_fou.role='scientifique_fou'
			scientifique_fou.sexe=randi()%2
			for i in range(NB_REPLIQUES_NORMALES):
				scientifique_fou.repliques.append(repliques_scientifique_fou[randi()%repliques_scientifique_fou.size()])
			batiment.residents.append(scientifique_fou)
			ville.habitants.append(scientifique_fou)

func geneHabitants(ville):
	randomize()
	var nb_habitants_rue = randi()%10+5
	var roles_classiques = ['commerçant itinérant','fermier','ouvrier','soldat']
	
#	for n in range(nb_habitants_rue):
#		var hab=PNJ.instance()
#		hab.sexe=randi()%2
#		hab.role=roles_classiques[randi()%roles_classiques.size()]
#		ville.habitants.append(hab)
	
	var repliques_action_presente_batiment_bandit = ["Il est là, je tremble de terreur.",
	"Vite, il eest dans ce bâtiment, il va vus échapper !",
	"Je le vois, par pitié descendez le."]
	var repliques_action_presente_batiment_autre = ["Je l'ai vu, il est là ! Dans ",
	"Il semble qu'il vous soit passé sous le nez, il tout pile dans ",
	"Faîtes vite, il est dans "]
	for batiment in ville.batiments:
		for i in range(randi()%2+1):
			var lelu = ville.habitants[randi()%ville.habitants.size()]
			if lelu.acteur == "figurant":
				lelu.acteur = "temoin_batiment"
				lelu.replique_action_presente_batiment_bandit = repliques_action_presente_batiment_bandit[randi()%repliques_action_presente_batiment_bandit.size()]
				lelu.replique_action_presente_batiment_autre = repliques_action_presente_batiment_autre[randi()%repliques_action_presente_batiment_autre.size()]

	var repliques_action_courante = ["Ça promet du grabuge, il semble que votre bandit soit en train de "]
	for batiment in ville.batiments:
		if(batiment.residents.size() > 0):
			var lelu = batiment.residents[randi()%batiment.residents.size()]
			if lelu.acteur == "figurant":
				lelu.acteur = "temoin_action"
				lelu.replique_speciale=repliques_action_courante[randi()%repliques_action_courante.size()]


	var repliques_nom_bandit = ["Le bandit que vous recherchez semble avoir pour nom "+ville.bandit.nom+".",
		ville.bandit.nom+", c'est son nom. Maintenant cessez de me parler.",
		"S'il vous plait, aidez nous, son nom c'est "+ville.bandit.nom+"."]
	for i in range(3):
		var lelu = ville.habitants[randi()%ville.habitants.size()]
		if lelu.acteur == "figurant":
			lelu.acteur = "clef"
			lelu.replique_speciale=repliques_nom_bandit[randi()%repliques_nom_bandit.size()]
	
	var repliques_sexe_bandit
	if(ville.bandit.sexe==HOMME):
		repliques_sexe_bandit = ["L'homme que vous recherchez... c'est un homme.",
		"Un indice, vous recherchez un homme.",
		"Votre proie, c'est un male."]
	else:
		repliques_sexe_bandit = ["L'homme que vous recherchez... ce n'est pas un homme.",
		"Ne vous fiez pas à ces traits, c'est un femme, et elle bien le double de violence d'un homme.",
		"Prenez garde, c'est une femme extrèment dangeureuse."]
	for i in range(3):
		var lelu = ville.habitants[randi()%ville.habitants.size()]
		if lelu.acteur == "figurant":
			lelu.acteur = "clef"
			lelu.replique_speciale=repliques_sexe_bandit[randi()%repliques_sexe_bandit.size()]
	
	var repliques_action_future = ["Faîtes attention, j'ai cru entendre qu'il allait ",
	"Il semble que celui que vous recherchez prévoie de ",
	"Prenez garde, je les ai entendu parler de "]
	for action in ville.actions:
		for i in range(3):
			var lelu = ville.habitants[randi()%ville.habitants.size()]
			if lelu.acteur == "figurant":
				lelu.acteur = "clef"
				lelu.replique_speciale=repliques_action_future[randi()%repliques_action_future.size()]+action[0]+"."
#	for hab in ville.habitants:		
#		var affectation = randi()%4
#		if affectation==0:
#			hab.acteur="figurant"
#			ville.hab_figurants.append(hab)
#		elif affectation==1:
#			hab.acteur="clef"
#			ville.hab_clefs.append(hab)
#		elif affectation==2:
#			hab.acteur="commere"
#			ville.hab_commeres.append(hab)
#		elif affectation==3:
#			hab.acteur="negociateur"
#			ville.hab_negociateurs.append(hab)
			
	