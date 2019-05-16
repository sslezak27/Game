extends KinematicBody2D

var shockvawe = load("res://Enemies/Golem/Attacks/Shockwave.tscn")
var veli;
var vel = Vector2(500,0)
const grav = 60
var hp = 3
var dmg = 1
var state = 'default'
var collision_info
var playerpos

func _physics_process(delta):
	if state != 'dead' and state != 'stun':
		playerpos = get_parent().get_node("Player").position
		if state != 'attack':
			if playerpos.x > position.x:
				vel.x = 50
			else:
				vel.x = -50
		if $Cd.is_stopped():
			attack()
		vel.y = 0
		collision_info =  move_and_collide(vel * delta)
		if collision_info:
			if collision_info.collider.has_method("hit"):
				var y = collision_info.collider.hit()
				match y:
					1:
						vel = vel.slide(vel)
						vel.y = 0
					'wall':
						vel = vel.slide(vel)
						vel.x = 0
						vel.y = vel.y+grav
					'top':
						vel = vel.slide(vel)
						vel.y = 0
				

#func onhit(dmg):
#	hp -= dmg
#	if hp <= 0:
#		$AnimatedSprite.queue_free()
#		$CollisionShape2D.queue_free()
#		$Timer.queue_free()
#		$Teleport.queue_free()
#		alive = false



func attack():
	
	
	var attack = shockvawe.instance()		
	veli = get_parent().get_node("Player").position
	if  veli.x - position.x < 0:
		attack.setup(Vector2(-200,0),position,dmg,2)
	else:
		attack.setup(Vector2(200,0),position,dmg,1)
	
	get_parent().add_child(attack)
	$Cd.wait_time = 2.5
	$Cd.start()




func hit():
	return 1