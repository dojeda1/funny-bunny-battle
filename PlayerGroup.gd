extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var players = []
var turn_index : int = 0
var focus_index: int = 0
var active_ability = null

onready var abilities = $"%Abilities"
onready var battle_arena = get_parent()
onready var enemy_group = battle_arena.get_node("EnemyGroup")

signal start_enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	players = get_children()
	players[turn_index].get_focus()
	show_abilities()
#	for i in enemies.size():
#		enemies[i].position = Vector2(0, i*64)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !abilities.visible:
		if Input.is_action_just_pressed("ui_up"):
			if enemy_group.focus_index > 0:
				enemy_group.focus_index -= 1
				enemy_group.switch_focus(enemy_group.focus_index, enemy_group.focus_index + 1)
		if Input.is_action_just_pressed("ui_down"):
			if enemy_group.focus_index < enemy_group.enemies.size() - 1:
				enemy_group.focus_index += 1
				enemy_group.switch_focus(enemy_group.focus_index, enemy_group.focus_index - 1)
		if Input.is_action_just_pressed("ui_accept"):
	#		enemies[index].damage(power)
#			action_queue.push_back(focus_index)
			activate_action(active_ability, enemy_group.focus_index)
		
#	if action_queue.size() == players.size() and !is_battling:
#		is_battling = true
#		_action(action_queue)
#	if action_queue.size() > 0 and !is_battling:
#		is_battling = true
#		_action(action_queue)
	pass
	
func activate_action(action, target):
	enemy_group._reset_focus()
	var player = players[turn_index]
	if action == "joke":
		players[turn_index].joke()
		enemy_group.enemies[target].damage(player.joke_power)
		next_player()
	if battle_arena.player_turn:
		switch_focus(turn_index, turn_index - 1)
		show_abilities()
	else:
		_reset_focus()
		_reset_turns()
		emit_signal("start_enemy")



func _on_EnemyGroup_start_player():
	players[0].get_focus()
	player_turn()

func show_abilities():
	abilities.show()
	abilities.find_node("Joke").grab_focus()

func switch_focus(x, y):
	players[x].get_focus()
	players[y].lose_focus()
	
func _reset_focus():
	focus_index = 0
	for player in players:
		player.lose_focus()
		
func _reset_turns():
	turn_index = 0

func next_player():
	print(turn_index, players.size() - 1)
	if turn_index < players.size() - 1:
		turn_index += 1
		focus_index = turn_index
		switch_focus(focus_index, focus_index - 1)
	else:
		battle_arena.player_turn = false
		_reset_turns()
		_reset_focus()
		emit_signal("begin_enemy_turn")
#		switch_focus(index, players.size() - 1)
	pass # Replace with function body.

func player_turn():
	if !players[turn_index].is_dead:
		show_abilities()
	else:
		print('DEAD')
		next_player()

func _on_Joke_pressed():
	active_ability = "joke"
	abilities.hide()
	_start_choosing()
	pass # Replace with function body.

func _start_choosing():
	enemy_group.enemies[0].get_focus()
