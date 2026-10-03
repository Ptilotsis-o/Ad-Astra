extends Area2D

@export var self_id: int = 0
@export var target_id: int = 0

var _player_in_area: CharacterBody2D = null
var _cooldown: bool = false

func _ready() -> void:
	add_to_group("transport")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_area = body

func _on_body_exited(body: Node2D) -> void:
	if body == _player_in_area:
		_player_in_area = null

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_area and not _cooldown and Input.is_action_pressed("interact"):
		_teleport(_player_in_area)
		get_viewport().set_input_as_handled()

func _teleport(player: CharacterBody2D) -> void:
	var target := _find_target()
	if target == null:
		return

	_do_teleport.call_deferred(player, target)

func _do_teleport(player: CharacterBody2D, target: Area2D) -> void:
	player.global_position = target.global_position
	_start_cooldown()
	target._start_cooldown()

func _start_cooldown() -> void:
	_cooldown = true
	await get_tree().create_timer(0.3).timeout
	_cooldown = false

func _find_target() -> Area2D:
	for node in get_tree().get_nodes_in_group("transport"):
		if node is Area2D and node.self_id == target_id:
			return node
	return null
