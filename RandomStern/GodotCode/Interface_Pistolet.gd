extends Control

var etape_courante = "Dégainer"

func degainer():
	get_node("AnimationPlayer").play("Degainer")
	etape_courante = "Dégainer"

func charger():
	if(etape_courante=="Dégainer"):
		get_node("AnimationPlayer").play("Charger")
		etape_courante = "Charger"

func tirer():
	if(etape_courante == "Charger" || etape_courante=="Tir"):
		get_node("AnimationPlayer").play("Tirer")
		etape_courante = "Tirer"
				
func tir():
	var anim = get_node("AnimationPlayer")
	if(etape_courante == "Tirer"):
		anim.play("Tir")
		etape_courante="Tir"
		