# The score manager makes a few assumptions namely that:
# - No player is allowed to join after the game has started.
# - When a player leaves, they are simply removed from the board.
extends Node

var logger := Logger.new("ScoreManager")
var player_placement: Dictionary = {}
var worst_place = 0

func _ready() -> void:
	PlayerManager.player_joined.connect(_on_player_joined)
	PlayerManager.player_left.connect(_on_player_left)
	logger.log("Subscribed to player joined/left signal")
	return

## Whenever a player joins, set their place to unplaced/invalid
func _on_player_joined(player: int) -> void:
	player_placement[str(player)] = -1
	worst_place = min(PlayerManager.MAX_PLAYERS, worst_place+1)
	logger.log("New player joined - %d" % [worst_place])
	
## Whenever a player leaves, remove them from the player placement board
func _on_player_left(player: int) -> void:
	if player_placement.has(player):
		player_placement.erase(player)

## [TODO] Need to subscribe to a signal for player death
## Updates the player placement table by checking for the last
## place given, and if none have been given yet, set as worst
## place (which should be == to # of people joined).
func _on_player_died(player: int) -> void:
	var current_place = player_placement.values().max()
	if current_place < 0:
		current_place = worst_place
	else:
		current_place -= 1
	player_placement[player] = current_place
	logger.log("Player %d placed %d" % [player, current_place])
