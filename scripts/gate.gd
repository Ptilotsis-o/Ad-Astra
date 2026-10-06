extends Area2D

var _player_in_area: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_area = false

func _physics_process(delta: float) -> void:
	if _player_in_area and Input.is_action_just_pressed("interact"):
		Eventbus.level_finished.emit(global_position)
