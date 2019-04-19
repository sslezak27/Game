extends KinematicBody2D


var speed = 0.03
var collision_info
var firespeed = Vector2()
var y
var dmg

func setup(vector,pos,rot,dmag):
	if vector.x >=0:
		vector.x += speed
		pos.x+= 100

	else:
		vector.x -= speed
		pos.x -= 100
	firespeed = vector
	speed = vector
	position = pos
	dmg = dmag

	rotation = rot

#func _ready(vector):



func _physics_process(delta):
	collision_info = move_and_collide(firespeed*delta)
	if collision_info:
		if collision_info.collider.has_method("onhit"):
			y = collision_info.collider.onhit(dmg)
		$AnimatedSprite.queue_free()
		$CollisionShape2D.queue_free()
