extends Node2D

class_name CharacterController

@export var body: CharacterBody2D
@export var inputHandler: Node

@export var speed := 1.0

func _process(delta: float):
	body.velocity = inputHandler.input.move * delta * speed
	body.move_and_slide()