extends KinematicBody2D


const grav = 10
const wspeed = 200
const jump =  -450
var vel = Vector2()
var jumping = true
var jumph = 0
var jumphmax = 1
var inair = 1
func _physics_process(delta):



	if Input.is_action_pressed("ui_left"):
		vel.x = -wspeed
	elif Input.is_action_pressed("ui_right"):
		vel.x = wspeed
	else:
		vel.x = 0
#	if !is_on_floor():
	vel.y += grav
	if Input.is_action_pressed("ui_up") and !jumping and jumph < jumphmax:
		jumph += 0.1
	if Input.is_action_just_released("ui_up") and !jumping:
		jumping = true
		vel.y = jump * jumph
		jumph = 0
	if Input.is_action_pressed("ui_down") and !jumping and !inair:
		$AnimatedSprite.play('crouch')
	else:
		$AnimatedSprite.play('default')
	
	if Input.is_action_just_released('ui_attack'):
		$AnimatedSprite.play('crouch')
	
	var speed = vel
#	var collision_info =  move_and_collide(speed,Vector2(0,-1))
	var collision_info =  move_and_collide(speed * delta)
	if collision_info:
		if collision_info.collider.has_method("hit"):
			var y = collision_info.collider.hit()
			match y:
				3:
					vel = vel.bounce(collision_info.normal)
					vel.y  += 100
					inair = true
					if vel.y < 0:
						jumping = false
				1:
					vel = vel.slide(collision_info.normal)
					jumping = false
					inair = false
					vel.y = 0
				