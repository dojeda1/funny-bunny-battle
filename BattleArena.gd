extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_turn = true
onready var player_group = $PlayerGroup
onready var enemy_group = $EnemyGroup
onready var graveyard = $Graveyard
onready var end_game_label = $"%EndGameLabel"
onready var replay = $"%Replay"


# Called when the node enters the scene tree for the first time.
func _ready():
	end_game_label.hide()
	replay.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_win():
	$BattleTheme.stop()
	$EndMusicTimer.start()
	end_game_label.text = "Free Funny Bunny!"

func game_lose():
	end_game_label.text = "To The Dungeon!"
	end_game_label.show()
	print("TO THE DUNGEON!")
	show_replay()

func show_replay():
	replay.show()
	replay.grab_focus()

func _on_EndMusicTimer_timeout():
	$VictoryTheme.play()
	print("FREEDOM GRANTED!")
	end_game_label.show()
	show_replay()
	pass # Replace with function body.


func _on_Replay_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
