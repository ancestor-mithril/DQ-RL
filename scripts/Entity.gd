extends "res://scripts/PhysicsEntity.gd"

var stats = {
	"health" : 0,
	"mana" : 100,
	"stagger_default" : 10,
	"stagger_health" : 10,
	"invincible" : false,
	"default_speed": 100
}

func take_damage(value, stagger, direction, impulse_force):
	if not stats['invincible'] and is_network_master():
		rpc("do_take_damage", value, stagger, direction, impulse_force)

sync func do_take_damage(value, stagger, direction, impulse_force):
	stats['health'] -= value
	stats['stagger_health'] -= stagger
	on_take_damage(direction, impulse_force)
	
func on_take_damage(direction, impulse_force):
	if stats['stagger_health'] <= 0:
		animation_dict["animation"] = "hit"
		animation_change = true
		stats['stagger_health'] = stats['stagger_default']
	$Health.text = String(stats['health'])
	animation_play = true
	animation_play_what = ""
	if stats['health'] <= 0:
		$Health.text = 'dead!'
		$Health.add_color_override("font_color", Color(255, 0, 0))
	pass

sync func do_set_health(value):
	stats['health'] = value
	stats['max_health'] = value
	$HealthLabel.text = String(stats["health"])

func set_initial_health(value):
#	Should be called only from master
	rpc("do_set_health", value)


sync func do_modify_stats(status, value):
	stats[status] 	+= value
	if status == 'health':
		$HealthLabel.text = String(stats['health'])


func modify_stats(status, value):
	if is_network_master():
		rpc("do_modify_stats", status, value)


sync func do_set_stats(status, value):
	stats[status] 	= value
	if status == 'health':
		$HealthLabel.text = String(stats['health'])


func set_stats(status, value):
	if is_network_master():
		rpc("do_set_stats", status, value)
