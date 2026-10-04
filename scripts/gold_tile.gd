extends RigidBody2D

@export var GoldNeeded = 1

@onready var player : CharacterBody2D = $"../../../ActorsAndCharacters/Player"

func _process(delta: float) -> void:
	if player.gold >= GoldNeeded:
		queue_free()
