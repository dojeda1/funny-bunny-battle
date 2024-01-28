extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var players = []
var turn_index : int = 0
var focus_index: int = 0
var active_ability = null
var can_select_target = false

onready var abilities = $"%Abilities"
onready var battle_arena = get_parent()
onready var enemy_group = battle_arena.get_node("EnemyGroup")

signal start_enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	reindex()
	players[turn_index].get_focus()
	show_abilities()
#	for i in enemies.size():
#		enemies[i].position = Vector2(0, i*64)
	pass # Replace with function body.
func reindex():
	players = get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !abilities.visible and battle_arena.player_turn and can_select_target:
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
	can_select_target = false
	enemy_group._reset_focus()
	var player = players[turn_index]
	if action == "joke":
		players[turn_index].joke()
		enemy_group.enemies[target].damage(player.joke_power)
	if action == "trip":
		players[turn_index].trip()
		enemy_group.enemies[target].damage(player.trip_power)

func _on_EnemyGroup_start_player():
	if players.size() > 0:
		players[0].get_focus()
		player_turn()
	else:
		print("GAME OVER")

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

func next_actor():
	print("Next Actor")
	if turn_index < players.size() - 1:
		turn_index += 1
		focus_index = turn_index
		switch_focus(focus_index, focus_index - 1)
		show_abilities()
		print('Player ', turn_index)
	else:
		battle_arena.player_turn = false
		_reset_turns()
		_reset_focus()
		emit_signal("start_enemy")
		print('Begin Enemy Turn')
#		switch_focus(index, players.size() - 1)
	pass # Replace with function body.

func player_turn():
	print("Player Turn")
	if !players[turn_index].is_dead:
		show_abilities()
	else:
		print('DEAD')
		next_actor()

func _start_choosing():
	can_select_target = true
	enemy_group.enemies[0].get_focus()

func _on_Joke_pressed():
	active_ability = "joke"
	abilities.hide()
	_start_choosing()
	pass # Replace with function body.

func _on_Trip_pressed():
	active_ability = "trip"
	abilities.hide()
	_start_choosing()
	pass # Replace with function body.
