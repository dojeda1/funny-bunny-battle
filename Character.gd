extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ap = $"%AnimationPlayer"
onready var health_bar = $"%HealthBar"
onready var focus = $"%Focus"
onready var hurt_sfx = $"%Hurt"
onready var die_sfx = $"%Die"
onready var joke_sfx = $"%Joke"
onready var trip_sfx = $"%Trip"
onready var bonk_sfx = $"%Bonk"
onready var text_bubble = $"%TextBubble"
onready var battle_arena = get_parent().get_parent()

export var health: int = 100
export var MAX_HEALTH = 100
export var joke_power = 10
export var trip_power = 10
export var resistance: String = "none"
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	text_bubble.hide()
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
	
func damage(value, type):
	if type == resistance:
		value -= 6
	update_health(-value)
	ap.play("hurt")
	hurt_sfx.play()

func die():
	is_dead = true

func end_die():
	var og_parent = get_parent()
	og_parent.remove_child(self) # error here  
	battle_arena.graveyard.add_child(self)
	og_parent.reindex()
	
#func _play_animation():
#	ap.play("hurt")

func end_hurt():
	if is_dead:
		ap.play("die")
		die_sfx.play()
		health_bar.hide()
		end_die()
	else:
		ap.play("idle")
		
func end_move():
	next_actor()
	ap.play("idle")
	text_bubble.hide()
	
func get_focus():
	focus.show()
	
func lose_focus():
	focus.hide()
	
func joke():
	joke_sfx.play()
	ap.play("joke")
	text_bubble.show()
	
func trip():
	trip_sfx.play()
	ap.play("trip")
	
func play_bonk():
	bonk_sfx.play()
	
func next_actor():
	get_parent().next_actor()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
