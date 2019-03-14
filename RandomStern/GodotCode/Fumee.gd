extends Node2D

var sprite

func _ready():
	sprite = get_node("Sprite")
	sprite.set_opacity(0.6)
	sprite.set_scale(Vector2(0.25,0.25))
	set_process(true)

func _process(delta):
	var sprite = get_node("Sprite")
	
	var scale = sprite.get_scale()
	
	sprite.set_scale(scale+Vector2( (randi()%20)/17 , (randi()%20)/17 ))
	sprite.set_opacity(sprite.get_opacity()-0.01)
	
	if(sprite.get_scale()>Vector2(10,10)):
		self.queue_free()