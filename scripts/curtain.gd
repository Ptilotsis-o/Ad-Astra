# 试验功能，未实现

extends Sprite2D
@export var player: CharacterBody2D

var mat: ShaderMaterial = material

func _process(delta: float) -> void:
	return
	
	visible = true
	var uv = get_player_uv(player)
	mat.set_shader_parameter("position",uv)
	var tween := create_tween()
	tween.tween_method(
		func(v): mat.set_shader_parameter("progress", v),
		0.0, 10.0, 1
	)
	await tween.finished 
	
	tween = create_tween()
	tween.tween_method(
		func(v): mat.set_shader_parameter("progress", v),
		10.0, 0.0, 0.4
	)
	await tween.finished
	
	
func get_player_uv(player: Node2D) -> Vector2:
	var size = get_viewport().get_visible_rect().size
	var pos = (player.global_position - (global_position- size/2) )
	return 2*pos / size
