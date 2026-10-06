extends RigidBody2D

@export var GoldNeeded = 1

func _physics_process(delta: float) -> void:
	if Eventbus.gold >= GoldNeeded:
		queue_free()
