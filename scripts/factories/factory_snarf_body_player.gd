extends Node

var body_prefab = preload("res://scenes/entities/SnarfBody.tscn")
var input_handler_prefab = preload("res://scenes/input/PlayerInput.tscn")

func instantiate(player_index: int, device_id: int):
    var snarf_body: SnarfBody = body_prefab.instantiate()
    snarf_body.name = "Player " + str(player_index);

    var input_handler: PlayerInput = input_handler_prefab.instantiate()
    input_handler.device_id = device_id

    snarf_body.add_child(input_handler)
    snarf_body.input_handler = input_handler

    return snarf_body