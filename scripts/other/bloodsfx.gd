extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	self.queue_free()
