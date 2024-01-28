extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var players = []
var turn_index : int = 0
var focus_index: int = 0

onready var abilities = $"%Abilities"
onready var battle_arena = get_parent()
onready var enemies = battle_arena.get_node("EnemyGroup").enemies

signal next_enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	players = get_children()
	players[turn_index].get_focus()
#	for i in enemies.size():
#		enemies[i].position = Vector2(0, i*64)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemyGroup_next_player():
	next_player()

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
		print('player move')
		turn_index += 1
		focus_index = turn_index
		switch_focus(focus_index, focus_index - 1)
	else:
		print('Enemy Turn')
		battle_arena.player_turn = false
		_reset_turns()
		_reset_focus()
		emit_signal("next_enemy")
#		switch_focus(index, players.size() - 1)
	pass # Replace with function body.
