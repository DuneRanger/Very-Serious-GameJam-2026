class_name RouletteBallManager

var balls: Array[RouletteBall] = []
var roulette

func _init(parent_roulette: Roulette) -> void:
	roulette = parent_roulette

func prepare_ball(ball: RouletteBall) -> void:
	ball.hide()
	ball.z_index = 1
	ball.freeze = true
	roulette.add_child(ball)

func prepare_balls():
	for ball in balls:
		prepare_ball(ball)

func prepare_initial_balls() -> void:
	balls = [RouletteBall.new()]
	prepare_balls()

func full_reset() -> void:
	for ball in balls:
		roulette.remove_child(ball)
		ball.queue_free()
	balls.clear()
	prepare_initial_balls()

func add_ball():
	var ball = RouletteBall.new()
	prepare_ball(ball)
	balls.append(ball)

func show_balls():
	for ball in balls:
		ball.show()

func hide_balls():
	for ball in balls:
		ball.hide()

func freeze_balls():
	for ball in balls:
		ball.freeze = true

func unfreeze_balls():
	for ball in balls:
		ball.freeze = false

func position_balls():
	for ball in balls:
		var start_position = Roulette.get_random_vector2(roulette.outer_circle_radius - 2 * RouletteBall.ball_radius)
		ball.reset_ball(start_position)

func launch_balls(direction: int):
	show_balls()
	unfreeze_balls()
	position_balls()
	for ball in balls:
		var normal = Vector2(-ball.init_position.y, ball.init_position.x).normalized()
		ball.launch(normal * 800 * direction)
