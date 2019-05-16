extends KinematicBody2D




const grav = 10
const wspeed = 400
const jump =  -550
var vel = Vector2()
var tempvel = Vector2()
var jumping = true
var inair = 1
var tp = false
var speed;
var collision_info;
var hp = 4;
var alive = true


var alpha = Vector2()
var temppos = Vector2()


func _init():
	pass



func _physics_process(delta):
	 

	if alive:
		$Label.text = str(hp)
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
		if tp:
			vel.x *= 2
		vel.y += grav
		if Input.is_action_just_released("ui_up") and !jumping:
			jumping = true
			vel.y = -500
			vel.x =0
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
						vel = vel.bounce(vel)
						vel.y  -= 100
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
					'hit':
						die()
					
		tempvel = vel
		
		

func teleport(y):
	match y:
		1:#start tp
		#	$AnimatedSprite.play('tp')
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

		
func onhit(dmg):
	die()



		
		
func die():
	alive = false
	hp = get_tree().get_current_scene()
	get_tree().change_scene(get_tree().get_current_scene().filename)
func aim():
	$Aim.global_position = get_viewport().get_mouse_position()


	