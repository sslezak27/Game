extends KinematicBody2D


var speed = Vector2()

var collision_info
var y
var dmg
var obr

func setup(pos,dmag):
	
	
	
#	obr = [[cos(rot), -sin(rot)], [sin(rot),cos(rot)]]


	
#	if vector.x >=0:


#	else:
#		vector.x -= speed
#	if rot < 180
#		pos.x -= 100
#	firespeed = vector.rotated(-rot)
#	firespeed.x = vector.x *cos(rot) + vector.y*sin(rot)
#	firespeed.y = vector.y  * cos(rot) - vector.x*sin(rot) 

#	speed = speed.rotated(rot)
	position = pos
	dmg = dmag

#	rotation = rot

#func _ready(vector):



func _physics_process(delta):
	collision_info = move_and_collide(Vector2(0,0))
	if collision_info:
		if collision_info.collider.has_method("onhit"):
			y = collision_info.collider.onhit(dmg)
			$CollisionPolygon2D.queue_free()
			$Sprite.queue_free()
			$Timer.queue_free()
	
