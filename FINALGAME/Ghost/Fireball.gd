extends KinematicBody2D


var speed = Vector2()

var collision_info
var firespeed = Vector2()
var y
var dmg
var obr

func setup(vector,pos,rot,dmag):
	
	
	
#	obr = [[cos(rot), -sin(rot)], [sin(rot),cos(rot)]]
	speed.y = 0;
	speed.x = 500;
	
#	if vector.x >=0:
	vector.x = speed.x
	vector.y = speed.y


#	else:
#		vector.x -= speed
#	if rot < 180
#		pos.x -= 100
	speed = vector
#	firespeed = vector.rotated(-rot)
#	firespeed.x = vector.x *cos(rot) + vector.y*sin(rot)
#	firespeed.y = vector.y  * cos(rot) - vector.x*sin(rot) 
	firespeed = speed.x * rot

#	speed = speed.rotated(rot)
	position = pos
	dmg = dmag

#	rotation = rot

#func _ready(vector):



func _physics_process(delta):
	collision_info = move_and_collide(firespeed*delta)
	if collision_info:
		if collision_info.collider.has_method("onhit"):
			y = collision_info.collider.onhit(dmg)
		$AnimatedSprite.queue_free()
		$CollisionShape2D.queue_free()
