extends Area2D

@onready var first_guide: Label = $"../FirstGuide"

@export var label: Label
@export var self_id : int = 1

var _player_in_area: bool = false

func _ready() -> void:
	label.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_area = false

func _physics_process(delta: float) -> void:
	if self_id == 0 and first_guide != null:
		_first_guide()
	if _player_in_area and Input.is_action_just_pressed("interact"):
		label.show()
	if !_player_in_area:
		label.hide()
	
func _first_guide() -> void:
	if _player_in_area:
		first_guide.show()
	if !_player_in_area:
		first_guide.hide()
