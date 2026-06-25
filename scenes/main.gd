extends Node2D

@export var main_menu_scene_preloaded : PackedScene
@export var game_scene_preloaded : PackedScene
@export var shop_scene_preloaded : PackedScene

var scenes = {}

var current_scene

var saved_game

var main_menu_scene
var game_scene
var shop_scene

func _ready() -> void:
	
	saved_game = null
	
	main_menu_scene = main_menu_scene_preloaded.instantiate()
	game_scene = null
	shop_scene = null
	
	GameManagerGlobal.current_showed_scene = GameEnums.switching_scenes.MAIN_MENU_SCENE
	current_scene = main_menu_scene
	GameManagerGlobal.signal_switch_scene.connect(scene_switch)

func get_main_menu_scene():
	if main_menu_scene == null:
		main_menu_scene = main_menu_scene_preloaded.instantiate()
		saved_game = main_menu_scene

func get_game_scene():
	if game_scene == null:
		game_scene = game_scene_preloaded.instantiate()
		saved_game = game_scene

func get_shop_scene():
	if shop_scene == null:
		shop_scene = shop_scene_preloaded.instantiate()

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
	match new_scene:
		GameEnums.switching_scenes.GAME_SCENE:
			get_game_scene()
			reparent_scenes(game_scene)
		GameEnums.switching_scenes.SHOP_SCENE:
			get_shop_scene()
			reparent_scenes(shop_scene)
		GameEnums.switching_scenes.MAIN_MENU_SCENE:
			reparent_scenes(main_menu_scene)
		_:
			pass
			
