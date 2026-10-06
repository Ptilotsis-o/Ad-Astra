extends Node2D

const LEVEL_TEST = preload("res://scenes/prefabs/level/level_test.tscn")
const LEVEL_TEMPLATE = preload("res://scenes/prefabs/level/level_template.tscn")
const LEVEL_01 = preload("res://scenes/prefabs/level/level_01.tscn")
const LEVEL_02 = preload("res://scenes/prefabs/level/level_02.tscn")
const LEVEL_03 = preload("res://scenes/prefabs/level/level_03.tscn")
const LEVEL_04 = preload("res://scenes/prefabs/level/level_04.tscn")
const LEVEL_05 = preload("res://scenes/prefabs/level/level_05.tscn")
const LEVEL_06 = preload("res://scenes/prefabs/level/level_06.tscn")
const LEVEL_07 = preload("res://scenes/prefabs/level/level_07.tscn")

const LEVEL_END = preload("res://scenes/prefabs/level/level_end.tscn")

const SceneList = [LEVEL_01, LEVEL_02, LEVEL_03, LEVEL_04, LEVEL_05, LEVEL_06, LEVEL_07, LEVEL_END]

var LevelIndex: int = 0
var player: CharacterBody2D
var _transitioning : bool = false

func _ready() -> void:
	Eventbus.level_finished.connect(next_level)
	Eventbus.PlayerDied.connect(player_died_restart)
	load_level(LevelIndex)

func player_died_restart(f) -> void:
	if _transitioning:
		return
	_transitioning = true
	get_tree().paused = true
	await Eventbus.AnimationFinished
	get_tree().paused = false
	load_level(LevelIndex)
	_transitioning = false

func next_level(f) -> void:
	if _transitioning:
		return
	_transitioning = true
	get_tree().paused = true
	await Eventbus.AnimationFinished
	get_tree().paused = false
	LevelIndex += 1
	load_level(LevelIndex)
	_transitioning = false

func load_level(i: int) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var scene = SceneList[i].instantiate()
	add_child(scene)
	
	Eventbus.gold = 0
	Eventbus.key = 0
