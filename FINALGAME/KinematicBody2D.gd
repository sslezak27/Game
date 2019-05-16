extends KinematicBody2D



var fireball = load("res://Player/Fireball.tscn")
var melee = load("res://Player/Attacks/Melee.tscn")

const grav = 10
const wspeed = 200
const jump =  -450
var vel = Vector2()
var tempvel = Vector2()
var jumping = true
var jumph = 0
var jumphmax = 1
var inair = 1
var tp = false
var speed;
var collision_info;
var hp = 4;
var alive = true
var dmg = 2
var playerpos
var attacking = 0

var alpha = Vector2()
var temppos = Vector2()


func _init():
	pass



func _physics_process(delta):
	 

	if alive:
		$Label.text = str(hp)
		if $Invul.is_stopped():
			set_collision_layer(2)
		aim()
		if Input.is_action_pressed("ui_left"):
			vel.x = -wspeed
	#		rotation += PI/2
		elif Input.is_action_pressed("ui_right"):
			vel.x = wspeed
		else:
			vel.x = 0
		#TELEPORT
		if Input.is_action_just_pressed('tp') and $Default.disabled == false and !tp and $TP.is_stopped():
			teleport(1)
		if tp and $TP.is_stopped():
			teleport(0)
		#KONIEC TP
	
		
		
		
		
	#	if !is_on_floor():
		vel.y += grav
		if Input.is_action_pressed("ui_up") and !jumping and jumph < jumphmax:
			jumph += 0.1
		if Input.is_action_just_released("ui_up") and !jumping:
			jumping = true
			vel.y = jump * jumph
			jumph = 0
		if Input.is_action_pressed("ui_down") and !jumping and !inair:
			crouch(1)
		if Input.is_action_just_released("ui_down"):
			crouch(0)
	
		if Input.is_action_just_released('ui_attack') and Input.is_action_pressed("ui_down"):
			attack('circle')
		elif Input.is_action_just_released('ui_attack') and !attacking:
			attack('fire')

			
		if $AttackTimer.is_stopped() and attacking:
			$Melee.queue_free()
			attacking = 0
	
		if tp:
			vel.x *= 2
		speed = vel
	#	var collision_info =  move_and_collide(speed,Vector2(0,-1))
		collision_info =  move_and_collide(speed * delta)
	#	RotatePlayer(tempvel,vel)
		if collision_info:
			if collision_info.collider.has_method("hit"):
				var y = collision_info.collider.hit()
				match y:
					# METODY DOTYCZNACE PODLOG
					3:
						vel = vel.bounce(collision_info.velocity)
						vel.y  += 100
						inair = true
						if vel.y < 0:
							jumping = false
					1:
						
						vel = vel.slide(vel)
						jumping = false
						inair = false
						vel.y = 0
						#METODY DOTYCZACE SCIAN
					'lwall':
						if Input.is_action_pressed('ui_left'):
							vel = vel.slide(vel)
							vel.x = 0
#							vel.y = tempvel.y+grav
							vel.y = 0
							jumping = false
						else:
							vel = vel.slide(vel)
							vel.x = 0
							vel.y = tempvel.y + grav
					'rwall':
						if Input.is_action_pressed('ui_right'):
							vel = vel.slide(vel)
							vel.x = 0
#							vel.y = tempvel.y+grav
							vel.y = 0
							jumping = false
						else:
							vel = vel.slide(vel)
							vel.x = 0
							vel.y = tempvel.y + grav
							
					# METODY DOTYcZACE SUFITY
					'top':
						vel = vel.slide(vel)
						vel.y = 0
					
		tempvel = vel
		
		
func crouch(y):
	match y:
		1:
			$AnimatedSprite.play('crouch')
			$Crouch.disabled = false
			$Default.disabled = true
		0:
			$AnimatedSprite.play('default')
			$Default.disabled = false
			$Crouch.disabled = true
func teleport(y):
	match y:
		1:#start tp
		#	$AnimatedSprite.play('tp')
			$Crouch.disabled = true
			tp = true
			$TP.wait_time = 0.5
			$TP.start()
		0:#kill tp
			tp = false
			$TP.wait_time = 5
			$TP.start()
			$AnimatedSprite.play('default')
			$Default.disabled = false
#func RotatePlayer(start, finish):
#    var angle = start.angle_to_point(finish)
#    rotation = angle
func attack(y):
#		alpha = get_viewport().get_mouse_position().dot(position)/(position.length() * get_viewport().get_mouse_position().length())
#		alpha = g.normalized().dot(get_viewport().get_mouse_position().normalized())
#		alpha = (get_viewport().get_mouse_position().y - position.y)/(get_viewport().get_mouse_position().length())
#		alpha  =  acos(alpha)

		if y == 'fire':
			var firebal = fireball.instance()
			alpha = (get_viewport().get_mouse_position() - position).normalized()
			
			$AnimatedSprite.play('crouch')
			firebal.setup(vel,position,alpha,dmg)
			get_parent().add_child(firebal)
			$Attack.play('enabled')
		
		elif y == 'circle':
			var firebal
			$AnimatedSprite.play('crouch')
			temppos.x = position.x - 10
			temppos.y = position.y
			alpha.x = -1
			alpha.y = 0
			while(temppos.x < position.x + 11):
				firebal = fireball.instance()
				firebal.setup(vel,position,alpha,dmg)
				get_parent().add_child(firebal)
				if temppos.x == position.x:
					firebal = fireball.instance()
					temppos.y += 20
					alpha.y -= 2
					firebal.setup(vel,position,alpha,dmg)
					get_parent().add_child(firebal)
				temppos.x += 10
				temppos.y -= 10
				alpha.x+= 1
				alpha.y += 1
			$Attack.play('enabled')
		elif y == 'melee':
			var firebal = melee.instance()
			$AnimatedSprite.play('crouch')
			firebal.setup(position,dmg)
			add_child(firebal)
			$Attack.play('enabled')
			$AttackTimer.start()
		

		
func onhit(dmg):
	if $Invul.is_stopped():
		hp -= dmg
		if hp <= 0:
			die()
		$Invul.wait_time = 1
		$Invul.start()
		set_collision_layer(20)
		


		
		
func die():
	alive = false
func aim():
	$Aim.global_position = get_viewport().get_mouse_position()


	