#? Sourced from https://github.com/matjlars/godot-multiplayer-input/blob/main/addons/multiplayer_input/demo/player_manager.gd

extends Node

const MAP_JOIN = "player_ui_join"
const MAP_READY = "player_ui_ready"

# player is 0-3
# device is -1 for keyboard/mouse, 0+ for joypads
# these concepts seem similar but it is useful to separate them so for example, device 6 could control player 1.

signal player_joined(player)
signal player_left(player)

# map from player integer to dictionary of data
# the existence of a key in this dictionary means this player is joined.
# use get_player_data() and set_player_data() to use this dictionary.
var logger := Logger.new("PlayerManager")
var player_data: Dictionary = {}
var player_prefab = preload("res://scenes/entities/Player.tscn")

const MAX_PLAYERS = 4

func instantiate_player(index: int, device: int):
	var entity = player_prefab.instantiate()
	entity.name = "Player " + str(index);

	var player_input: PlayerInput = entity.get_node("PlayerInput")
	player_input.device_id = device

	add_child(entity)
	return entity

func join(device: int):
	var player = next_player()
	if player >= 0:
		# # initialize default player data here
		var entity = instantiate_player(player, device)
		player_data[player] = {
			"device": device,
			"entity": entity,
		}

		logger.log("Player %s joined. Device ID: %s" % [player + 1, device])
		player_joined.emit(player)

func leave(player: int):
	if player_data.has(player):
		player_data.erase(player)
		player_left.emit(player)

func get_player_count():
	return player_data.size()

func get_player_indexes():
	return player_data.keys()

func get_player_device(player: int) -> int:
	return get_player_data(player, "device")

# get player data.
# null means it doesn't exist.
func get_player_data(player: int, key: StringName):
	if player_data.has(player) and player_data[player].has(key):
		return player_data[player][key]
	return null

# set player data to get later
func set_player_data(player: int, key: StringName, value: Variant):
	# if this player is not joined, don't do anything:
	if !player_data.has(player):
		return
	
	player_data[player][key] = value

# call this from a loop in the main menu or anywhere they can join
# this is an example of how to look for an action on all devices
func handle_join_input():
	for device in get_unjoined_devices():
		if MultiplayerInput.is_action_just_pressed(device, MAP_JOIN):
			join(device)

# to see if anybody is pressing the "start" action
# this is an example of how to look for an action on all players
# note the difference between this and handle_join_input(). players vs devices.
func someone_wants_to_start() -> bool:
	for player in player_data:
		var device = get_player_device(player)
		if MultiplayerInput.is_action_just_pressed(device, MAP_READY):
			return true
	return false

func is_device_joined(device: int) -> bool:
	for player_id in player_data:
		var d = get_player_device(player_id)
		if device == d: return true
	return false

# returns a valid player integer for a new player.
# returns -1 if there is no room for a new player.
func next_player() -> int:
	for i in MAX_PLAYERS:
		if !player_data.has(i): return i
	return -1

# returns an array of all valid devices that are *not* associated with a joined player
func get_unjoined_devices():
	var devices = Input.get_connected_joypads()
	# also consider keyboard player
	devices.append(-1)
	
	# filter out devices that are joined:
	return devices.filter(func(device): return !is_device_joined(device))
