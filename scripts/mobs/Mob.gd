extends 'res://scripts/mobs/Mob_base.gd'

func _init():
	self.SPEED = 70

func attack_player(player):
	if can_attack:
		player.take_damage(attack_damage)
		move_and_slide(Vector2(velocity.x + 2000*direction*-1, velocity.y), Vector2(0, -1))
		can_attack = false
		attack_timer.start()

func _on_Hurtbox_area_entered(area):
	if area.is_in_group('hitbox'):
		var owner = area.get_owner()
		if owner.is_in_group('players'):
			attack_player(owner)