extends RigidBody2D
class_name RouletteBall

static func _make_circle_points(radius: float, segments: int) -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(segments):
		var angle = (float(i) / segments) * 2 * PI
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	return points

static func get_random_vector2(_max_x: float, _max_y: float, size: float) -> Vector2:
	var angle = randf_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)) * size

var rand_impulse_size : float = 1000

var min_speed_threshold : float = 5
var fast_slowdown_speed : float = 100
var max_speed : float = 10000
static var ball_radius : float = 8
static var ball_id : float = 0

## Marks the ball as settled and no longer updates physics
var settled : bool = false
var caught_cell : RouletteCell

var reset : bool = false
var init_position : Vector2

var launch_b : bool = false
var launch_vector : Vector2

func _init():
	mass = 1.0
	gravity_scale = 0
	name = "Ball %s" % ball_id
	ball_id += 1

	var phys_mat = PhysicsMaterial.new()
	phys_mat.bounce = 0.5
	phys_mat.friction = 0.0001
	physics_material_override = phys_mat

	# collision detecteion mode
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY

	var shape = CircleShape2D.new()
	shape.radius = ball_radius

	var collider = CollisionShape2D.new()
	collider.shape = shape
	add_child(collider)

	var visual = Polygon2D.new()
	visual.color = Color(0.929, 0.89, 0.561, 1.0)
	visual.polygon = _make_circle_points(shape.radius, 24)
	add_child(visual)

func give_random_impulse():
	apply_impulse(get_random_vector2(10, 10, rand_impulse_size))

func get_speed() -> float:
	return linear_velocity.length()

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if reset:
		position = init_position
		rotation = 0.0
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
		settled = false
		caught_cell = null
		reset = false
		return
	if launch_b:
		linear_velocity = launch_vector
		launch_b = false
		return

	var new_vel = state.linear_velocity
	if new_vel.length() < fast_slowdown_speed:
		new_vel *= 0.999
	elif new_vel.length() > max_speed:
		new_vel = new_vel.normalized() * max_speed
	#print("Ball speed: ", new_vel.length())

	state.linear_velocity = new_vel

func catch_in_pocket(cell: RouletteCell):
	settled = true
	caught_cell = cell

func reset_ball(start_position: Vector2):
	reset = true
	init_position = start_position

func launch(vec : Vector2):
	launch_b = true
	launch_vector = vec
