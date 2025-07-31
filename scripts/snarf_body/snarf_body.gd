extends CharacterBody2D

class_name SnarfBody

@export var input_handler: Node
@export var settings: SnarfBodySettings

func _physics_process(delta: float):
	velocity = input_handler.input.move * delta * settings.base_speed
	move_and_slide()