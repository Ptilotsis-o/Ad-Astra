extends Node2D

const LEVEL_TEST = preload("res://scenes/prefabs/level/level_test.tscn")
const LEVEL_TEMPLATE = preload("res://scenes/prefabs/level/level_template.tscn")
const LEVEL_01 = preload("res://scenes/prefabs/level/level_01.tscn")
const LEVEL_02 = preload("res://scenes/prefabs/level/level_02.tscn")
const LEVEL_03 = preload("res://scenes/prefabs/level/level_03.tscn")

const SceneList = [LEVEL_01, LEVEL_02, LEVEL_03]

var LevelIndex: int = 0
var player: CharacterBody2D

func _ready() -> void:
	Eventbus.level_finished.connect(next_level)
	Eventbus.PlayerDied.connect(restart)
	load_level(LevelIndex)

func restart() -> void:
	load_level(LevelIndex)

func next_level() -> void:
	LevelIndex += 1
	if LevelIndex < len(SceneList):
		load_level(LevelIndex)

func load_level(i: int) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var scene = SceneList[i].instantiate()
	add_child(scene)
