# Simple scene manager - Must be autoloaded to work as is. 
# Will immediately load in the `initial_scene` and provides a
# helper function for loading scenes. Loading scenes this way provides the advantage of having the
# ability to keep scenes running or to delete them or to keep them in memory for faster swapping.
extends Node

var logger := Logger.new("SceneManager")
var current_scene = null

var initial_scene := "res://scenes/game.tscn"

func _ready() -> void:
	call_deferred("_load_scene", initial_scene, false, false)
	
func _load_scene(scene_path: String, delete: bool, hide: bool) -> void:
	logger.log("Loading scene from path %s - delete: %s - hide: %s" %[scene_path, delete, hide])
	var tree := get_tree()
	if current_scene:
		if delete:
			current_scene.queue_free()
			logger.log("Deleted current_scene.")
		elif hide:
			current_scene.hide()
			logger.log("current_scene hidden.")
		else:
			tree.root.remove_child(current_scene)
			logger.log("current_scene removed from tree.")

	var scene = load(scene_path).instantiate()
	tree.root.add_child(scene)
	tree.set_current_scene(scene)
	current_scene = scene
	logger.log("Scene loaded.")

## Loads the requested scene. If `delete` is true, it will delete the scene 
## (queue_free), if `hide` is true it will simply hide the scene (keeps it running in background)
## or if both are false, it'll simply remove it from the tree - essentially
## deleting it but keeping it in memory.
func load_scene(scene_path: String, delete: bool = true, hide: bool = false) -> void:
	call_deferred("_load_scene", scene_path, delete, hide)
	return
