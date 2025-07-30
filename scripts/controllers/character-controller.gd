extends Node2D

class_name CharacterController

@export var body: CharacterBody2D
@export var inputHandler: PlayerInput

@export var speed := 1.0

func _process(delta: float):
	body.velocity = inputHandler.input.move * delta * speed
	print(body.velocity)
	body.move_and_slide()