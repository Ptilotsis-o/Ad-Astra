extends CharacterBody2D

@export_category("移动参数")
@export var double_press_interval := 0.3
@export var move_speed: float = 75.0
@export var dash_speed: float = 400.0
@export var acceleration: float = 600.0
@export var deceleration: float = 800.0
@export var jump_velocity: float = -190.0

@onready var spawnpoint: Marker2D = $"../../Marks/PlayerSpawnpoint"
@onready var sprite: Sprite2D = $Sprite2D

var swimming : bool = false
var last_press_time := {
	"move_left": -10000,
	"move_right": -10000,
}
var gold : int = 0

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i).get_collider()
		if collision.has_method("on_body_entered"):
			collision.on_body_entered(self)

	if !swimming:
		apply_gravity(delta)
		handle_jump()
	else:
		handle_vertical_movement(delta)
	
	handle_horizontal_movement(delta)
	update_sprite_direction()
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_vertical_movement(delta:float) -> void:
	var direction := Input.get_axis("squat", "jump")
	var target_speed := direction * jump_velocity
	
	if direction != 0.0:
		velocity.y = move_toward(
				velocity.y,
				target_speed,
				acceleration * delta
		)
	else:
		velocity.y = move_toward(
				velocity.y,
				0.0,
				acceleration * delta
		)
	
func handle_horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
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

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func update_sprite_direction() -> void:
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		_try_dash(-1, "move_left", "move_right")
	elif event.is_action_pressed("move_right"):
		_try_dash(1, "move_right", "move_left")
	
func _try_dash(direction: int, action: String, opposite_action: String) -> void:
	
	var current_time := Time.get_ticks_msec()
	var elapsed_time : int = current_time - last_press_time[action]

	if elapsed_time <= double_press_interval * 1000.0:
		velocity.x = direction * dash_speed
		move_and_slide()
		last_press_time[action] = -10000
	else:
		last_press_time[action] = current_time

	last_press_time[opposite_action] = -10000
		
func die() -> void:
	Eventbus.PlayerDied.emit()
