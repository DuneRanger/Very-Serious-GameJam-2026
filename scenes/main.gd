extends Node2D

@export var game_scene_preloaded : PackedScene
@export var shop_scene_preloaded : PackedScene

var scenes = {}
var current_showed_scene : GameEnums.switching_scenes

var current_scene

var game_scene
var shop_scene

func _ready() -> void:
	current_showed_scene = GameEnums.switching_scenes.MAIN_MENU_SCENE
	
	current_scene = null
	
	game_scene = null
	shop_scene = null
	GameManagerGlobal.signal_switch_scene.connect(scene_switch)

func get_game_scene():
	if game_scene == null:
		game_scene = game_scene_preloaded.instantiate()

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

func _on_new_game_button_button_down() -> void:
	$MainMenu.visible = false
	scene_switch(GameEnums.switching_scenes.GAME_SCENE)

func scene_switch(new_scene : GameEnums.switching_scenes):
	match new_scene:
		GameEnums.switching_scenes.GAME_SCENE:
			get_game_scene()
			reparent_scenes(game_scene)
			current_showed_scene = GameEnums.switching_scenes.GAME_SCENE
		GameEnums.switching_scenes.SHOP_SCENE:
			get_shop_scene()
			reparent_scenes(shop_scene)
			current_showed_scene = GameEnums.switching_scenes.SHOP_SCENE
		GameEnums.switching_scenes.MAIN_MENU_SCENE:
			unparent_current_scene()
			$MainMenu.visible = true
			current_showed_scene = GameEnums.switching_scenes.MAIN_MENU_SCENE
			current_scene = null
		_:
			pass
			
