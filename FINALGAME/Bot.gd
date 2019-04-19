extends KinematicBody2D

var fireball = load("res://Enemies/BotAttack1.tscn")
var veli;
var projectilepos;
var speed = Vector2(500,0)
var alive = false
var y
var hp = 3
var dmg = 2


func _physics_process(delta):
	if alive:
#	veli = get_position("KinematicBody2D")
		projectilepos = position
		if $Timer.is_stopped():
			attack(1)
		if $Teleport.is_stopped():
			teleport()

func onhit(dmg):
	hp -= dmg
	if hp <= 0:
		$AnimatedSprite.queue_free()
		$CollisionShape2D.queue_free()
		$Timer.queue_free()
		$Teleport.queue_free()
		alive = false



func teleport():
	y = str(randi()%2+1)
	position = get_parent().get_node("Sor").get_node(y).position
	$Teleport.wait_time = 3
	$Teleport.start()

func attack(y):
	
		var firebal = fireball.instance()
#		
		veli = get_parent().get_node("Player").position
		projectilepos.y = veli.y
		speed.y = 1*veli.y
		if  veli.x - position.x < 0:
			speed.x = -abs(speed.x)
		else:
			speed.x = abs(speed.x)
		firebal.setup(speed,position,rotation,dmg)
		get_parent().add_child(firebal)
		$Timer.wait_time = 0.5
		$Timer.start()