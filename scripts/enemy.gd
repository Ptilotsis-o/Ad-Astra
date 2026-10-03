extends CharacterBody2D

@export_category("移动参数")
@export var double_press_interval := 0.3
@export var move_speed: float = 30.0
@export var acceleration: float = 600.0
@export var deceleration: float = 800.0
@export var jump_velocity: float = -190.0

@onready var player: CharacterBody2D = $"../Player"
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i).get_collider()
		if collision.has_method("on_body_entered"):
			collision.on_body_entered(self)

	apply_gravity(delta)
	handle_horizontal_movement(delta)
	update_sprite_direction()
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_horizontal_movement(delta: float) -> void:
	var direction := 1 if (player.global_position - global_position).x > 0 else -1
	var target_speed := direction * move_speed

	if direction != 0.0:
		velocity.x = move_toward(
				velocity.x,
				target_speed,
				acceleration * delta
		)
	else:
		velocity.x = move_toward(
				velocity.x,
				0.0,
				deceleration * delta
		)
		
func update_sprite_direction() -> void:
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x > 0.0
		
func on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		body.die()

func die() -> void:
	queue_free()
