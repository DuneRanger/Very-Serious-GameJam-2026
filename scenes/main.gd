extends Node2D

@export var main_menu_scene_preloaded : PackedScene
@export var game_scene_preloaded : PackedScene
@export var shop_scene_preloaded : PackedScene
@export var how_to_play_scene_preloaded : PackedScene

var game_started : bool

var scenes = {}

var current_scene

var saved_game

var main_menu_scene
var game_scene
var shop_scene
var how_to_play_scene

func _ready() -> void:
	
	saved_game = null
	
	main_menu_scene = main_menu_scene_preloaded.instantiate()
	how_to_play_scene = how_to_play_scene_preloaded.instantiate()
	game_scene = null
	shop_scene = null
	
	GameManagerGlobal.current_showed_scene = GameEnums.switching_scenes.MAIN_MENU_SCENE
	current_scene = main_menu_scene
	add_child(main_menu_scene)
	GameManagerGlobal.signal_switch_scene.connect(scene_switch)

func new_game():
	game_started = true
	game_scene = game_scene_preloaded.instantiate()
	shop_scene = shop_scene_preloaded.instantiate()
	add_child(game_scene)
	add_child(shop_scene)
	GameManagerGlobal.game_start()
	remove_child(game_scene)
	remove_child(shop_scene)
	#please dont ask im tired boss

func unparent_current_scene():
	if current_scene != null:
		if current_scene.get_parent() != null:
			remove_child(current_scene)

func reparent_scenes(new_scene):
	unparent_current_scene()
	current_scene = new_scene
	add_child(new_scene)

func scene_switch(new_scene : GameEnums.switching_scenes):
	GameManagerGlobal.current_showed_scene = new_scene
	if !game_started:
		new_game()
	match new_scene:
		GameEnums.switching_scenes.HOW_TO_PLAY_SCENE:
			reparent_scenes(how_to_play_scene)
		GameEnums.switching_scenes.GAME_SCENE:
			reparent_scenes(game_scene)
		GameEnums.switching_scenes.SHOP_SCENE:
			reparent_scenes(shop_scene)
		GameEnums.switching_scenes.MAIN_MENU_SCENE:
			reparent_scenes(main_menu_scene)
		_:
			pass
			
