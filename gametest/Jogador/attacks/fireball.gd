extends Area2D

var level = 1
var healph = 1
var speed = 200
var damage = 5
var knockback_amount = 150
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() #+ deg_to_rad(135)
	match level:
		1:
			healph = 2 #2 atravessa 1 inimigo e some no próximo
			speed = 200
			damage = 100
			knockback_amount = 150
			attack_size = 1.0
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	position += angle*speed*delta

func enemy_hit(charge = 1):
	healph -= charge
	if healph <= 0:
		emit_signal("remove_from_array", self)
		queue_free()

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
