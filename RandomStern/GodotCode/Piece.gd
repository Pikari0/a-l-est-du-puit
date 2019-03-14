extends Control

signal piece_au_sol

var animation
var chrono = 0

var sol = false

func _ready():
	self.animation = get_node("AnimationPlayer")
	animation.play("tombe")
	set_process(true)

func _process(delta):
	self.chrono += delta
	if(self.chrono > 5 && !self.sol):
		self.sol = true
		self.animation.play("sol")

func _on_AnimationPlayer_finished():
	self.emit_signal("piece_au_sol")
