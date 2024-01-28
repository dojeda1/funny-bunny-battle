extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var players = []
var index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	players = get_children()
	players[index].get_focus()
#	for i in enemies.size():
#		enemies[i].position = Vector2(0, i*64)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemyGroup_next_player():
	if index < players.size() - 1:
		index += 1
		switch_focus(index, index - 1)
	else:
		index = 0
		switch_focus(index, players.size() - 1)
	pass # Replace with function body.

func switch_focus(x, y):
	players[x].get_focus()
	players[y].lose_focus()
