extends RigidBody2D

func on_body_entered(body: CharacterBody2D) ->void:
	if body.has_method("die"):
		body.die()
