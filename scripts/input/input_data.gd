extends Resource

class_name InputData

@export var move: Vector2;
@export var look: Vector2;
@export var dash: bool;
@export var catch: bool;
@export var throw: bool;

func clear():
	move = Vector2.ZERO
	look = Vector2.ZERO
	dash = false
	catch = false
	throw = false