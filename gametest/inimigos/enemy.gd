extends CharacterBody2D

@export var movement_speed = 60.0
@export var healph = 40
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")

var death_anim = preload("res://inimigos/explosion.tscn")

signal remove_from_array(object)

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false

func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale/10
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	healph -= damage
	knockback = angle * knockback_amount
	if healph <= 0:
		death()
