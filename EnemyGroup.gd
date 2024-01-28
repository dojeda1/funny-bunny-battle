extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0
var power: int = 10

signal next_player
onready var abilities = $"%Abilities"
onready var players = get_parent().get_node("PlayerGroup").players
# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = get_children()
#	for i in enemies.size():
#		enemies[i].position = Vector2(0, i*64)
	show_choice()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !abilities.visible:
		if Input.is_action_just_pressed("ui_up"):
			if index > 0:
				index -= 1
				switch_focus(index, index + 1)
		if Input.is_action_just_pressed("ui_down"):
			if index < enemies.size() - 1:
				index += 1
				switch_focus(index, index - 1)
		if Input.is_action_just_pressed("ui_accept"):
	#		enemies[index].damage(power)
			action_queue.push_back(index)
			emit_signal("next_player")
		
	if action_queue.size() == players.size() and !is_battling:
		is_battling = true
		_action(action_queue)
	pass
	
func _action(stack):
	for i in stack:
		enemies[i].damage(power)
#		await get_tree().create_timer(1).timeout
	action_queue.clear()
	is_battling = false
	show_choice()

func switch_focus(x, y):
	enemies[x].get_focus()
	enemies[y].lose_focus()
	
func show_choice():
	abilities.show()
	abilities.find_node("Joke").grab_focus()
	
func _reset_focus():
	index = 0
	for enemy in enemies:
		enemy.lose_focus()

func _start_choosing():
	_reset_focus()
	enemies[0].get_focus()

func _on_Joke_pressed():
	abilities.hide()
	_start_choosing()
	pass # Replace with function body.
