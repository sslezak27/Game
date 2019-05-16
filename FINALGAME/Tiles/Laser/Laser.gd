extends AnimatedSprite

var fireball = load("res://Enemies/BotAttack1.tscn")
export var time = 0.5
export var speed = Vector2(200,0)
var dmg = 1


func _physics_process(delta):
	if $Timer.is_stopped():
		attack()
		
func attack():
	
		var firebal = fireball.instance()
		firebal.setup(speed,position,rotation,dmg)
		get_parent().add_child(firebal)
		$Timer.wait_time = time
		$Timer.start()

