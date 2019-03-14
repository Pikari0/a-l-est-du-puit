extends Sprite

func _on_Wanted_visibility_changed():
	get_node("AnimationPlayer").play("Running")
	
func change_nom_bandit(nom):
	get_node("Nom_Bandit").set_text(nom)
	get_node("Prime").set_text(str(randi()%1000)+"00 $")