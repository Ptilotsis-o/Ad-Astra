extends RigidBody2D

@export var GoldNeeded = 1

func _process(delta: float) -> void:
	if Eventbus.gold >= GoldNeeded:
		queue_free()
