extends KinematicBody2D

var fireball = load("res://Enemies/BotAttack1.tscn")
var veli;
var projectilepos;
var vel = Vector2(500,0)
const grav = 60
var alive = true
var y
var hp = 3
var dmg = 2
var state = 'default'
var collision_info
var playerpos

func _physics_process(delta):
	if alive:
		playerpos = get_parent().get_node("Player").position
		if state != 'under':
			if playerpos.x > position.x:
				vel.x = 50
			else:
				vel.x = -50

		if $Under.is_stopped() and state == 'default':
			underground(1)
		elif $Under.is_stopped() and state == 'dunder':
			underground(2)
		elif $Under.is_stopped() and state == 'ounder':
			underground(3)
		if state == 'ounder':
			vel.y += grav * delta
#	veli = get_position("KinematicBody2D")
#		if $Timer.is_stopped():
#			underground()
		collision_info =  move_and_collide(vel * delta)
	#	RotatePlayer(tempvel,vel)
		if collision_info:
			if collision_info.collider.has_method("hit"):
				var y = collision_info.collider.hit()
				if state == 'under':
					set_collision_mask(8)
					state = 'dunder'
					$Under.wait_time = 5
					$Under.start()
				else:
					match y:
						3:
							vel = vel.bounce(collision_info.velocity)
							vel.y  += 100
						1:
							if state == 'ounder':
								state = 'default'
								$Under.wait_time = 3
								$Under.start()
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



func underground(g):
	match g:
		1:
			state = 'under'
		#	$Passive.disabled = true
		#	$Underground.disabled = false
			vel.y = 200
		2:
			set_collision_mask(8)
			vel.y = -400
			$Under.wait_time = 5
			$Under.start()
			state = 'ounder'
		3:
			set_collision_mask(1)

#func attack(y):
#
#		var firebal = fireball.instance()
##		
#		veli = get_parent().get_node("Player").position
#		projectilepos.y = veli.y
#		speed.y = 1*veli.y
#		if  veli.x - position.x < 0:
#			speed.x = -abs(speed.x)
#		else:
#			speed.x = abs(speed.x)
#		firebal.setup(speed,position,rotation,dmg)
#		get_parent().add_child(firebal)
#		$Timer.wait_time = 0.5
#		$Timer.start()