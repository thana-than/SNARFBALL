extends Node

class_name PlayerLobby

func _process(_delta):
	PlayerManager.handle_join_input()
