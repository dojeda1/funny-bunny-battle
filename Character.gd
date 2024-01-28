extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ap = $"%AnimationPlayer"
onready var health_bar = $"%HealthBar"
onready var focus = $"%Focus"
onready var hurt_sfx = $"%Hurt"
onready var die_sfx = $"%Die"

var health: int = 100
var MAX_HEALTH = 100
var joke_power = 10
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = MAX_HEALTH
	_update_health_bar()
	ap.play("idle")
	pass # Replace with function body.

func update_health(value):
		health += value
		health = clamp(health, 0, MAX_HEALTH)
		if health == 0:
			die()
		_update_health_bar()

func _update_health_bar():
#	health_bar.value = (health/MAX_HEALTH) * 100
	health_bar.value = health
	
func damage(value):
	update_health(-value)
	ap.play("hurt")
	hurt_sfx.play()

func die():
	is_dead = true

#func _play_animation():
#	ap.play("hurt")

func end_hurt():
	if is_dead:
		ap.play("die")
		die_sfx.play()
		health_bar.hide()
	else:
		ap.play("idle")
		
func end_move():
	ap.play("idle")
	
func get_focus():
	focus.show()
	
func lose_focus():
	focus.hide()
	
func joke():
	ap.play("joke")
	
func trip():
	ap.play("trip")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
