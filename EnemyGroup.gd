extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var turn_index: int = 0
var focus_index: int = 0
var power: int = 10

signal next_player
onready var abilities = $"%Abilities"
onready var battle_arena = get_parent()
#onready var players = battle_arena.player_group.players
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
			if focus_index > 0:
				focus_index -= 1
				switch_focus(focus_index, focus_index + 1)
		if Input.is_action_just_pressed("ui_down"):
			if focus_index < enemies.size() - 1:
				focus_index += 1
				switch_focus(focus_index, focus_index - 1)
		if Input.is_action_just_pressed("ui_accept"):
	#		enemies[index].damage(power)
			action_queue.push_back(focus_index)
		
#	if action_queue.size() == players.size() and !is_battling:
#		is_battling = true
#		_action(action_queue)
	if action_queue.size() > 0 and !is_battling:
		is_battling = true
		_action(action_queue)
	pass
	
func _action(stack):
	battle_arena.player_group.players[battle_arena.player_group.turn_index].joke()
	for i in stack:
		enemies[i].damage(power)
#		await get_tree().create_timer(1).timeout
	action_queue.clear()
	is_battling = false
	emit_signal("next_player")
	if battle_arena.player_turn:
		_reset_focus()
		show_choice()
	else:
		next_enemy()

func switch_focus(x, y):
	enemies[x].get_focus()
	enemies[y].lose_focus()
	
func show_choice():
	abilities.show()
	abilities.find_node("Joke").grab_focus()
	
func _reset_focus():
	focus_index = 0
	for enemy in enemies:
		enemy.lose_focus()
		
func _reset_turns():
	turn_index = 0

func _start_choosing():
	_reset_focus()
	enemies[0].get_focus()

func _on_Joke_pressed():
	abilities.hide()
	_start_choosing()
	pass # Replace with function body.

func next_enemy():
	activate_move()
	if turn_index < enemies.size() - 1:
		turn_index += 1
#		switch_focus(index, index - 1)
		next_enemy()
	else:
		turn_index = 0
		battle_arena.player_turn = true
		emit_signal("next_player")
		_reset_turns()
		_reset_focus()
#		switch_focus(index, players.size() - 1)
	pass # Replace with function body.

func _on_PlayerGroup_next_enemy():
	next_enemy()
	pass # Replace with function body.

func activate_move():
	enemies[turn_index].joke()
	randomize()
	var rng = RandomNumberGenerator.new()
	var rand_player = rng.randi_range(0, battle_arena.player_group.players.size() - 1)
	print("attack player ", rand_player)
	battle_arena.player_group.players[rand_player].damage(power)
	
#	next_enemy()
