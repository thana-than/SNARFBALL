extends Node2D

class_name PlayerInput

@export var mousePixelsPerUnit = 100.0

var move: Vector2;
var look: Vector2;

func get_movement_input():
	var input = Input.get_vector("player_move_left", "player_move_right", "player_move_up", "player_move_down")
	return input

func get_look_input():
	var input = Input.get_vector("player_look_left", "player_look_right", "player_look_up", "player_look_down")
	if input == Vector2.ZERO:
		input = get_mouse_look()
	return input

func get_mouse_look():
	var mouse = (get_viewport().get_mouse_position() - position) / mousePixelsPerUnit
	mouse.x = clamp(mouse.x, -1.0, 1.0)
	mouse.y = clamp(mouse.y, -1.0, 1.0)
	return mouse

func _process(_delta: float):
	var _move = get_movement_input()
	var _look = get_look_input()
	
	#* Look value fallbacks
	if _look == Vector2.ZERO:
		_look = _move
	if _look == Vector2.ZERO:
		_look = look

	move = _move
	look = _look
	return
