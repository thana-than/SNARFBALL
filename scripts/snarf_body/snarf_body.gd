extends CharacterBody2D

class_name SnarfBody

#region Properties, Fields, Variables

@export var input_handler: Node
@export var settings: SnarfBodySettings
@onready var look_root := get_node("Look")

var move_buffer: Vector2
var look_rotation_buffer: float

var state_default = DefaultState.new()
var state_dashAttack = DashAttackState.new()
var state_ballHeld = BallHeldState.new()

var state_machine := preload("res://scripts/state_machine/state_machine.gd").new(state_default)
var ctx := StateContext.new()

var input: InputData:
	get:
		return input_handler.input

#endregion


#region StateContext

class StateContext:
	var body: SnarfBody
	var input: InputData
	var settings: SnarfBodySettings

func update_ctx():
	ctx.body = self
	ctx.input = input
	ctx.settings = self.settings
	return

#endregion

#region Engine Methods

func _ready():
	update_ctx()
	state_machine.restart(ctx)

func _process(delta: float):
	#update_ctx()
	state_machine.process(delta, ctx)
	look_root.rotation = look_rotation_buffer

func _physics_process(delta: float):
	#update_ctx()
	state_machine.physics_process(delta, ctx)

	velocity = move_buffer * delta * settings.base_speed
	move_and_slide()


#endregion

#region States

class SnarfBodyState:
	extends State

class DefaultState:
	extends SnarfBodyState

	func _process(_delta: float, _ctx: StateContext) -> State:
		_ctx.body.move_buffer = _ctx.input.move
		_ctx.body.look_rotation_buffer = _ctx.input.look.angle()
		return self

class DashAttackState:
	extends SnarfBodyState

class BallHeldState:
	extends SnarfBodyState

#endregion
