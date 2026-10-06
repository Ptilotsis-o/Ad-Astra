# 试验功能，未实现

extends Sprite2D

var mat: ShaderMaterial = material

func _ready() -> void:
	visible = false
	Eventbus.PlayerDied.connect(player_move)
	Eventbus.PlayerReady.connect(player_arrive)
	Eventbus.level_finished.connect(player_move)

func player_move(posi : Vector2) ->void:
	Eventbus.AnimationStarted.emit()
	visible = true
	global_position = posi
	var uv = Vector2(0.5,0.5)
	mat.set_shader_parameter("position",uv)
	var tween := create_tween()
	tween.tween_method(
		func(v): mat.set_shader_parameter("progress", v),
		1.5, -0.5, 1
	)
	await tween.finished
	visible = false
	Eventbus.AnimationFinished.emit()

func player_arrive(posi : Vector2) ->void:
	Eventbus.AnimationStarted.emit()
	visible = true
	global_position = posi
	var uv = Vector2(0.5,0.5)
	mat.set_shader_parameter("position",uv)
	var tween := create_tween()
	tween.tween_method(
		func(v): mat.set_shader_parameter("progress", v),
		-0.5, 1.5, 1
	)
	await tween.finished
	visible = false
	Eventbus.AnimationFinished.emit()
