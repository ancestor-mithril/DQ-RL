extends 'res://scripts/Weapons/Weapon_base.gd'



const bullet = preload("res://scenes/Weapons/WeaponProjectile_bullet.tscn")

var stagger_damage = 0

func _init():
	lighticon = preload("res://.import/weapon_red_magic_staff.png-a8006a78b318d13d52112b4cee52b729.stex")
	specialicon = lighticon
	self.attack_damage = 5
	LightAttack_CD.wait_time = 0.6
	SpecialAttack_CD.wait_time = 4
	attack_anim_names['attack'] = 'attack'
	attack_anim_names['special-attack'] = 'special-attack'

sync func do_attack():
	on_attack_sfx()
	var bullet_inst = bullet.instance()
	get_tree().get_root().add_child(bullet_inst)
	bullet_inst.global_position = self.global_position
	bullet_inst.attack_damage = self.attack_damage + get_parent().stats['damage_modifier']
	bullet_inst.direction = -1 if int($AnimatedSprite.flip_h) else 1


func attack():
	rpc_unreliable("do_attack")


func on_attack_sfx():
	$ProjectileSfx.play()


func special_attack():
	rpc_unreliable("play_animation", attack_anim_names['special-attack'])
	on_special_attack_sfx()

func on_special_attack_sfx():
	$BeamSfx.play()
	

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("hitbox"):
		var owner = area.get_owner()
		if owner.is_in_group('mobs'):
			#on_enemyhit_sfx()	
			owner.take_damage(attack_damage + get_parent().stats['damage_modifier'] * 2,
			stagger_damage,
			Vector2(-1 if $AnimatedSprite.flip_h else 1, 0), 50)
