extends Node2D

class_name PlayerInput

const MAP_MOVE_AXES = ["player_move_left", "player_move_right", "player_move_up", "player_move_down"]
const MAP_LOOK_AXES = ["player_look_left", "player_look_right", "player_look_up", "player_look_down"]
const MAP_ACTION = "player_action"

@export var mousePixelsPerUnit = 100.0
@export var device_id := -1
@export var input: InputData = InputData.new()

func _get_movement_input():
	var _move = MultiplayerInput.get_vector(device_id, MAP_MOVE_AXES[0], MAP_MOVE_AXES[1], MAP_MOVE_AXES[2], MAP_MOVE_AXES[3])
	return _move

func _get_look_input():
	var _look = MultiplayerInput.get_vector(device_id, MAP_LOOK_AXES[0], MAP_LOOK_AXES[1], MAP_LOOK_AXES[2], MAP_LOOK_AXES[3])
	if _look == Vector2.ZERO and device_id < 0:
		_look = _get_local_mouse_look()
	return _look

func _get_local_mouse_look():
	var _mouse = (get_viewport().get_mouse_position() - position) / mousePixelsPerUnit
	_mouse = _mouse.limit_length(1.0)
	return _mouse

func _get_action_input():
	var _action = MultiplayerInput.is_action_pressed(device_id, MAP_ACTION);
	return _action

func _process(_delta: float):
	if device_id >= 0 and not Input.is_joy_known(device_id):
		input.clear()
		return

	var _move = _get_movement_input()
	var _look = _get_look_input()
	var _action = _get_action_input()
	
	#* Look value fallbacks
	if _look == Vector2.ZERO:
		_look = _move
	if _look == Vector2.ZERO:
		_look = input.look

	input.move = _move
	input.look = _look

	#* Most action inputs take from the one button input. We let the controllers handle how they are actually parsed.
	#* This is in case we need to eventually add other control schemes
	input.dash = _action
	input.catch = _action
	input.throw = _action
	return
